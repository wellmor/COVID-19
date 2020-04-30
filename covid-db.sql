-- MySQL Script generated by MySQL Workbench
-- Thu Apr 30 13:43:37 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema covid_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema covid_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `covid_db` DEFAULT CHARACTER SET utf8 ;
USE `covid_db` ;

-- -----------------------------------------------------
-- Table `covid_db`.`Mesorregiao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Mesorregiao` (
  `idMesorregiao` INT NOT NULL AUTO_INCREMENT,
  `nomeMesorregiao` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idMesorregiao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_db`.`Micorregiao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Micorregiao` (
  `idMicrorregiao` INT NOT NULL AUTO_INCREMENT,
  `nomeMicrorregiao` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idMicrorregiao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_db`.`Municipio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Municipio` (
  `idMunicipio` INT NOT NULL AUTO_INCREMENT,
  `idMesorregiao` INT NOT NULL,
  `idMicrorregiao` INT NOT NULL,
  `nomeMunicipio` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idMunicipio`),
  INDEX `idMesorregiao_idx` (`idMesorregiao` ASC),
  INDEX `idMicrorregiao_idx` (`idMicrorregiao` ASC),
  CONSTRAINT `idMesorregiao`
    FOREIGN KEY (`idMesorregiao`)
    REFERENCES `covid_db`.`Mesorregiao` (`idMesorregiao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idMicrorregiao`
    FOREIGN KEY (`idMicrorregiao`)
    REFERENCES `covid_db`.`Micorregiao` (`idMicrorregiao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_db`.`Pessoa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Pessoa` (
  `idPessoa` INT NOT NULL AUTO_INCREMENT,
  `idMunicipio` INT NOT NULL,
  `nomePessoa` VARCHAR(100) NOT NULL,
  `cpfPessoa` VARCHAR(11) NOT NULL,
  `rgPessoa` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`idPessoa`),
  INDEX `idMunicipio_idx` (`idMunicipio` ASC),
  CONSTRAINT `idMunicipio`
    FOREIGN KEY (`idMunicipio`)
    REFERENCES `covid_db`.`Municipio` (`idMunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_db`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Usuario` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `idPessoa` INT NOT NULL,
  `emailUsuario` VARCHAR(100) NOT NULL,
  `senhaUsuario` VARCHAR(100) NOT NULL,
  `nivelUsuario` INT NOT NULL,
  `fotoUsuario` VARCHAR(30) NOT NULL,
  `notificacoesUsuario` TINYINT NOT NULL,
  `celularUsuario` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  INDEX `idPessoaX_idx` (`idPessoa` ASC),
  CONSTRAINT `idPessoaX`
    FOREIGN KEY (`idPessoa`)
    REFERENCES `covid_db`.`Pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_db`.`Tipo_Caso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Tipo_Caso` (
  `idTipoCaso` INT NOT NULL AUTO_INCREMENT,
  `descricaoTipoCaso` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idTipoCaso`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_db`.`Caso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Caso` (
  `idCaso` INT NOT NULL AUTO_INCREMENT,
  `idTipoCaso` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  `idMunicipio` INT NOT NULL,
  `dataCaso` DATETIME NOT NULL,
  PRIMARY KEY (`idCaso`),
  INDEX `idTipoCasoX_idx` (`idTipoCaso` ASC),
  INDEX `idUsuarioY_idx` (`idUsuario` ASC),
  INDEX `idLocalizacao_idx` (`idMunicipio` ASC),
  CONSTRAINT `idTipoCasoX`
    FOREIGN KEY (`idTipoCaso`)
    REFERENCES `covid_db`.`Tipo_Caso` (`idTipoCaso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idUsuarioY`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `covid_db`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idMunicipioY`
    FOREIGN KEY (`idMunicipio`)
    REFERENCES `covid_db`.`Municipio` (`idMunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_db`.`Noticia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Noticia` (
  `idNoticia` INT NOT NULL AUTO_INCREMENT,
  `idUsuario` INT NOT NULL,
  `idMunicipio` INT NOT NULL,
  `tituloNoticia` VARCHAR(100) NOT NULL,
  `textoNoticia` TEXT NOT NULL,
  `dataNoticia` DATETIME NOT NULL,
  `fonteNoticia` TEXT NOT NULL,
  PRIMARY KEY (`idNoticia`),
  INDEX `idUsuarioZ_idx` (`idUsuario` ASC),
  INDEX `idLocalizacaoZ_idx` (`idMunicipio` ASC),
  CONSTRAINT `idUsuarioZ`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `covid_db`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idMunicipioZ`
    FOREIGN KEY (`idMunicipio`)
    REFERENCES `covid_db`.`Municipio` (`idMunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_db`.`Doacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Doacao` (
  `idDoacao` INT NOT NULL AUTO_INCREMENT,
  `idPessoa` INT NOT NULL,
  `idMunicipio` INT NOT NULL,
  `tipoDoacao` VARCHAR(100) NOT NULL,
  `informacoesDoacao` TEXT NOT NULL,
  `statusDoacao` TINYINT NULL,
  PRIMARY KEY (`idDoacao`),
  INDEX `idPessoaL_idx` (`idPessoa` ASC),
  INDEX `idLocalizacaoC_idx` (`idMunicipio` ASC),
  CONSTRAINT `idPessoaL`
    FOREIGN KEY (`idPessoa`)
    REFERENCES `covid_db`.`Pessoa` (`idPessoa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idMunicipioH`
    FOREIGN KEY (`idMunicipio`)
    REFERENCES `covid_db`.`Municipio` (`idMunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_db`.`Projeto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Projeto` (
  `idProjeto` INT NOT NULL AUTO_INCREMENT,
  `idUsuario` INT NOT NULL,
  `idMunicipio` INT NOT NULL,
  `tituloProjeto` VARCHAR(100) NOT NULL,
  `descricaoProjeto` VARCHAR(100) NOT NULL,
  `informacoesProjeto` TEXT NOT NULL,
  `urlProjeto` VARCHAR(100) NULL,
  `dataProjeto` DATETIME NOT NULL,
  PRIMARY KEY (`idProjeto`),
  INDEX `idUsuarioI_idx` (`idUsuario` ASC),
  INDEX `idLocalizacaoI_idx` (`idMunicipio` ASC),
  CONSTRAINT `idUsuarioI`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `covid_db`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idMunicipioX`
    FOREIGN KEY (`idMunicipio`)
    REFERENCES `covid_db`.`Municipio` (`idMunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `covid_db`.`Alerta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `covid_db`.`Alerta` (
  `idAlerta` INT NOT NULL AUTO_INCREMENT,
  `idUsuario` INT NOT NULL,
  `idMunicipio` INT NOT NULL,
  `dataAlerta` DATETIME NOT NULL,
  `tituloAlerta` VARCHAR(100) NOT NULL,
  `conteudoAlerta` TEXT NOT NULL,
  PRIMARY KEY (`idAlerta`),
  INDEX `idUsuarioJ_idx` (`idUsuario` ASC),
  INDEX `idLocalizacaoJ_idx` (`idMunicipio` ASC),
  CONSTRAINT `idUsuarioJ`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `covid_db`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idMunicipioJ`
    FOREIGN KEY (`idMunicipio`)
    REFERENCES `covid_db`.`Municipio` (`idMunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
