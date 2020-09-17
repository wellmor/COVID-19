<?php

namespace App\Controllers;

use App\Models\AlertasModel;
use App\Models\MunicipiosModel;


class Alerta extends BaseController
{
	public function muncipio_wpp()
	{
		#http://localhost/alerta/muncipio_wpp
		$model = new AlertasModel();
		$query = $model->query("SELECT municipio.nomeMunicipio, alerta.numeroWpp as numeroWhatsapp FROM municipio INNER JOIN alerta ON municipio.idMunicipio = alerta.idMunicipio");
		die(json_encode($query->getResult('array'), JSON_PRETTY_PRINT));
	}

	public function salvarWpp($idMunicipio = 57, $numeroWpp)
	{
		$model = new AlertasModel();
		$data = [
			'idMunicipio' => $idMunicipio,
			'numeroWpp' => $numeroWpp
		];
		if ($model->save($data)) return "Sucesso";
		else return "Erro";
	}

	public function municipio($idMunicipio = 57)
	{
		$model = new AlertasModel();
		$query = $model->query('SELECT nomeMunicipio FROM municipio WHERE idMunicipio = ' . $idMunicipio);
		if (count($query->getResult('array')) == 0) die("Id inválido");
		$nomeMunicipio = $query->getResult('array')[0]['nomeMunicipio'];
		$query = $model->query('SELECT a.idOnesignal FROM alerta AS a INNER JOIN municipio as m WHERE a.idMunicipio=m.idMunicipio AND a.idMunicipio = ' . $idMunicipio);
		$data['municipio'] = array($nomeMunicipio, count($query->getResult('array')), $idMunicipio);
		return view('home/alerta', $data);
	}

	public function enviar($idMunicipio = null)
	{
		$model = new AlertasModel();
		$idMunicipio = $this->request->getVar('idMunicipio');
		$query = $model->query('SELECT a.idOnesignal, m.nomeMunicipio FROM alerta AS a INNER JOIN municipio as m WHERE a.idMunicipio=m.idMunicipio AND a.idMunicipio = ' . $idMunicipio);
		$nomeMunicipio = $query->getFirstRow('array')['nomeMunicipio'];
		$onesignal_ids = array();
		foreach ($query->getResult('array') as $result) {
			array_push($onesignal_ids, $result['idOnesignal']);
		}

		$content = array("en" => 'Novos casos confirmados em ' . $nomeMunicipio . ' clique para mais informações!');
		$fields = array(
			'app_id' => "5ea884de-aca8-4ffe-9325-83181ed98de1",
			'include_player_ids' => $onesignal_ids,
			'contents' => $content
		);

		$fields = json_encode($fields);
		//print("\nJSON sent:\n");
		//print($fields);
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, "https://onesignal.com/api/v1/notifications");
		curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			'Content-Type: application/json; charset=utf-8',
			'Authorization: Basic MDc4N2I5ZjktNzc1NC00MGYxLWFkMGQtMDZjNTA2Yjg0ZjMz'
		));
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
		curl_setopt($ch, CURLOPT_HEADER, FALSE);
		curl_setopt($ch, CURLOPT_POST, TRUE);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
		$response = curl_exec($ch);
		curl_close($ch);
		return $response;
	}

	public function salvar()
	{
		$model = new AlertasModel();
		$data = [
			'idMunicipio' => $this->request->getVar('idMunicipio'),
			'idOnesignal' => $this->request->getVar('idOnesignal'),
		];
		if ($model->save($data)) return "Sucesso!";
		else return "Erro";
	}

	public function delete($idOnesignal = null, $idMunicipio = null)
	{
		$model = new AlertasModel();
		$model->where('idOnesignal', $idOnesignal);
		$model->where('idMunicipio ', $idMunicipio);
		$model->delete();
	}

	public function verificaSeIdEstaEmMunicipio($idOnesignal = null, $idMunicipio = null)
	{
		$model = new AlertasModel();
		$consultaIdEmMunicipio = $model
			->where('idOnesignal', $idOnesignal)
			->where('idMunicipio', $idMunicipio)
			->first();
		if (!empty($consultaIdEmMunicipio))
			return "true";
		else return "false";
	}
}
