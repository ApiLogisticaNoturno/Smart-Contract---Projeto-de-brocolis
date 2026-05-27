// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CadeiaDoBrocolisV2 {
    
    enum Estagio { Plantado, EmTransporte, NaLoja, Vendido, Consumido }

    struct Brocolis {
        uint256 id;
        string lote;
        string produtor;
        string dataPlantio;
        Estagio estagioAtual;
        address responsavelAtual;
    }

    mapping(uint256 => Brocolis) public estoque;
    uint256 public totalBrocolis;

    event StatusAtualizado(uint256 id, Estagio novoEstagio, address responsavel);

    // [COMPUTADOR 1] - Etapa 1: PLANTAR
    function plantarBrocolis(string memory _lote, string memory _produtor, string memory _dataPlantio) public {
        totalBrocolis++;
        estoque[totalBrocolis] = Brocolis({
            id: totalBrocolis,
            lote: _lote,
            produtor: _produtor,
            dataPlantio: _dataPlantio,
            estagioAtual: Estagio.Plantado,
            responsavelAtual: msg.sender
        });
        emit StatusAtualizado(totalBrocolis, Estagio.Plantado, msg.sender);
    }

    // [COMPUTADOR 1] - Etapa 2: DESPACHAR
    function despacharParaTransporte(uint256 _id, address _transportador) public {
        Brocolis storage meuBrocolis = estoque[_id];
        require(meuBrocolis.estagioAtual == Estagio.Plantado, "Status invalido para transporte.");
        meuBrocolis.estagioAtual = Estagio.EmTransporte;
        meuBrocolis.responsavelAtual = _transportador;
        emit StatusAtualizado(_id, Estagio.EmTransporte, _transportador);
    }

    // [COMPUTADOR 2] - Etapa 3: ENTREGAR
    function receberNaLoja(uint256 _id, address _loja) public {
        Brocolis storage meuBrocolis = estoque[_id];
        require(meuBrocolis.estagioAtual == Estagio.EmTransporte, "O brocolis precisa estar em transporte.");
        meuBrocolis.estagioAtual = Estagio.NaLoja;
        meuBrocolis.responsavelAtual = _loja;
        emit StatusAtualizado(_id, Estagio.NaLoja, _loja);
    }

    // [COMPUTADOR 3] - Etapa 4: VENDER
    function venderParaCliente(uint256 _id, address _cliente) public {
        Brocolis storage meuBrocolis = estoque[_id];
        require(meuBrocolis.estagioAtual == Estagio.NaLoja, "O brocolis nao esta na loja para ser vendido.");
        meuBrocolis.estagioAtual = Estagio.Vendido;
        meuBrocolis.responsavelAtual = _cliente;
        emit StatusAtualizado(_id, Estagio.Vendido, _cliente);
    }

    // [COMPUTADOR 4] - Etapa 5: CONSUMIR
    function consumirBrocolis(uint256 _id) public {
        Brocolis storage meuBrocolis = estoque[_id];
        require(meuBrocolis.estagioAtual == Estagio.Vendido, "Voce precisa comprar o brocolis antes de consumir.");
        meuBrocolis.estagioAtual = Estagio.Consumido;
        meuBrocolis.responsavelAtual = msg.sender;
        emit StatusAtualizado(_id, Estagio.Consumido, msg.sender);
    }
}