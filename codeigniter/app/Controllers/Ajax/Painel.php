<?php

namespace App\Controllers\Ajax;

use App\Models\PainelModel;
use CodeIgniter\Controller;


class Painel extends Controller
{
    #http://localhost:8080/ajax/casos/getdados
    public function getDados()
    {
        $model = new PainelModel();
        $query = $model->query("SELECT m.nomeMunicipio as nome, m.idMunicipio as id, 
        IF(IFNULL(c.idCaso, '') = '', '-', c.idCaso) AS idCaso, 
        IF(IFNULL(v.idVerificacao, '') = '', '-', v.idVerificacao) AS idVerificacao, 
        IF(IFNULL(c.dataCaso, '') = '', '-', max(c.dataCaso)) AS maxDataCaso,
        IF(IFNULL(v.dataVerificacao, '') = '', '-', max(v.dataVerificacao)) AS maxDataVerificacao,
        IF(IFNULL(c.confirmadosCaso, '') = '', '-', c.confirmadosCaso) AS confirmados,
        IF(IFNULL(c.suspeitosCaso, '') = '', '-', c.suspeitosCaso) AS suspeitos,
        IF(IFNULL(c.descartadosCaso, '') = '', '-', c.descartadosCaso) AS descartados,
        IF(IFNULL(c.recuperadosCaso, '') = '', '-', c.recuperadosCaso) AS recuperados,
        IF(IFNULL(c.obitosCaso, '') = '', '-', c.obitosCaso) AS obitos
        FROM (
           caso c
           JOIN municipio m ON c.idMunicipio = m.idMunicipio AND c.deleted_at = '0000-00-00' AND c.auto = 0)
        LEFT JOIN verificacao v ON v.idMunicipio = c.idMunicipio
        GROUP BY c.idMunicipio");
        $dados = $query->getResult('array');
        $i = 0;
        $data = [];
        foreach ($dados as $x) {
            $data[$i]['nome'] = $x['nome'];
            $data[$i]['id'] = $x['id'];
            if ($x['maxDataCaso'] != '-')
                $data[$i]['maxDataCaso'] = date("d/m/Y", strtotime($x['maxDataCaso']));
            if ($x['maxDataVerificacao'] != '-')
                $data[$i]['maxDataVerificacao'] = date("d/m/Y", strtotime($x['maxDataVerificacao']));
            else
                $data[$i]['maxDataVerificacao'] = '-';

            if ($x['maxDataCaso'] == '-' && $x['maxDataVerificacao'] == '-') {
                $data[$i]['ultimaAtualizacao'] = 'Sem atualizações';
            } else if ($x['maxDataCaso'] == '-') {
                $data[$i]['ultimaAtualizacao'] = date("d/m/Y", strtotime($x['maxDataVerificacao']));
                $data[$i]['ultimaAtualizacaoNonFormatted'] = $x['maxDataVerificacao'];
            } else if ($x['maxDataVerificacao'] == '-') {
                $data[$i]['ultimaAtualizacao'] = date("d/m/Y", strtotime($x['maxDataCaso']));
                $data[$i]['ultimaAtualizacaoNonFormatted'] = $x['maxDataCaso'];
            } else if ($x['maxDataVerificacao'] > $x['maxDataCaso']) {
                $data[$i]['ultimaAtualizacao'] = date("d/m/Y", strtotime($x['maxDataVerificacao']));
                $data[$i]['ultimaAtualizacaoNonFormatted'] = $x['maxDataVerificacao'];
            } else if ($x['maxDataCaso'] >= $x['maxDataVerificacao']) {
                $data[$i]['ultimaAtualizacao'] = date("d/m/Y", strtotime($x['maxDataCaso']));
                $data[$i]['ultimaAtualizacaoNonFormatted'] = $x['maxDataCaso'];
            } else {
                $data[$i]['ultimaAtualizacao'] = 'Algo deu errado';
            }
            $i++;
        }

        $dados = [
            'data' => $data
        ];

        echo json_encode($dados);
    }
}
