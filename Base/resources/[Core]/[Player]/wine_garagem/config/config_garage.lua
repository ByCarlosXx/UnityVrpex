
Config = {}
Config.useLastGarage  = true -- com essa opção como true, o carro ficara somente em uma garagem por toda cidade, com ela false os carros ficam em todas as garagens
Config.LogoServidor = "https://cdn.discordapp.com/attachments/1018600153000722482/1024526839659630612/perfil.png" -- SUA LOGO DA CIDADE
Config.NomeServidor = "WINE STORE" -- NOME DO SERVIDOR
Config.imgDiret = "http://winestore.cloud/carros" -- DIRETÓRIO DAS IMAGENS DOS CARROS
Config.tabela = "vrp_user_vehicles" 
Config.Comandos = {
    --#[COMANDO CAR]
    ["commandCar"] = "car",
    ["permCar"] = "admin.permissao", 
    ["webhookCar"] = "",
    --#[COMANDO FIX]
    ["commandFix"] = "fix",
    ["permFix"] = "admin.permissao",
    ["webhookFix"] = "",
    --#[COMANDO DV]
    ["commandDv"] = "dv",
    ["permDv"] = "admin.permissao",
    ["webhookDv"] = "",
     --#[COMANDO DVALL]
    ["commandDvall"] = "dvall",
    ["permDvall"] = "admin.permissao",
    ["webhookDv"] = "",
    --#[COMANDO VEHS]
    ["commandVehs"] = "vehs", 
    ["webhookVehs"] = ""
}
 
Config.drawMaker = {
    -- CONFIG DE CADA DRAW MAKER PARA CADA MOMENTO NA GARAGEM . PEGUE AQUI OS NUMEROS DO DRAW MAKER ->https://docs.fivem.net/docs/game-references/markers/
    ["Entrar"] = 36,
    ["Sair"] = 3,
    ["Guardar"] = 36,
    -- CONFIG DA COR DO DRAW MAKER EM RGB
    ["CorR"] = 255,
    ["CorG"] = 0,
    ["CorB"] = 0
}

Config.BlipsGarage = {
    ['AparecerBlipsNoMapa'] = true, -- aparece automaticamente os blips no mapa das garagens
    ['BlipInMapa'] = 357,-- blip que ficara visivel no mapa para garagens publicas , pegue no site -> https://docs.fivem.net/docs/game-references/blips/
    ['TamanhoBlip'] = 0.5, -- tamanho do blip que fica no mapa das garagens publicas
    ['CorBlip'] = 3 -- cor do blip no mapa
}

Config.personalize = {
    ['VoltarColisao'] = 10, -- o valor longe da garagem volta a colisão
    ['TempoColisao'] = 30, -- se o player não se afastar a distancia acima após o tempo definido aqui a colisão volta
    ['DistanciaBlip'] = 3, -- distancia fora do carro que o blip aparece
    ['DistanciaBlipInCar'] = 5, -- distancia dentro do carro que o blip aparece
    ['GuardarCarroRoubado'] = true,-- se for true o player podera roubar o carro de outro jogador, abaixo defina os dias que fica na garagem do outro jogador
    ['DiaCarroRoubado'] = 3, -- dias que o carro pode permanecer dentro da garagem da pessoa que o roubou
    ['SpawnaInCar'] = true, -- player spawna dentro do carro em garagens de interface

}

--[[
    NAS GARAGENS ABAIXO VOCÊ TERÁ 6 OPÇÕES DE INTERIOR PARA PERSONALIZAR CADA GARAGEM
    EM ' ["name"] OU ["interior"] TERÁ UM = A "NOMEDOINTERIOR" COLOQUE UM DOS NOMES ABAIXO '

    pequena   -- INTERIOR PEQUENO [2 carros]
    media   -- INTERIOR MEDIO [5 carros]
    grande  -- INTERIOR GRANDE [12 carros]
    extra_grande -- INTERIOR EXTRA GRANDE [ 21 carros ]
    gigante  -- INTERIOR ENORME [23 carros]

    -- EXTRAS
    garage_mazebank -- GARAGEM QUE SE LOCALIZA NO MAZE BANK [ 6 carros ]
    garage_centro -- GARAGEM SE LOCALIZA NO CENTRO PROXIMO AO MAZE BANK [ 6 carros ]
]]

-- OBS : LEMBRE SE QUE A GARAGEM ELA SALVA ONDE VOCÊ DEIXOU O CARRO POR ULTIMO NA CIDADE! ELE SÓ FICA EM UMA GARAGEM 

--###############################################################
-- GARAGENS PUBLICAS ############################################
--###############################################################

Config.garages = { -- PARA DEIXAR BLIP NO MAPA ADICIONE A GARAGEM " ["publica"] = true, ['nameGarage'] = "NOME QUE APARECE NO MAPA", "
    [1] = { ["name"] = "luxuosa", ["payment"] = false, ["perm"] = false, ["publica"] = true, ['nameGarage'] = "Garagem da Praça", -- GARAGEM DA PRAÇA
        ["entrada"] = {
            ["blip"] = { 213.47, -931.86, 24.15 },
            ["veiculo"] = { 215.25, -932.58, 24.15,58.78 }
        },
        ["saida"] = { 215.25, -932.58, 24.15, 242.03 }
    },
    [2] = { ["name"] = "extra_grande", ["payment"] = false, ["perm"] = false, ["publica"] = true, ['nameGarage'] = "Garagem do Cassino", -- GARAGEM DO CASSINO
          ["entrada"] = {
                 ["blip"] = { 935.42, 0.47, 78.77 },
                 ["veiculo"] = { 934.67, -1.15, 78.77, 152.76 }
          },
    }, 
    [3] = { ["name"] = "garage_mazebank", ["payment"] = false, ["perm"] = false, ["publica"] = true, ['nameGarage'] = "Garagem do Maze Bank", -- GARAGEM NO MAZE BANK
         ["entrada"] = {
             ["blip"] = { -84.12, -820.91, 36.03 },
             ["veiculo"] = { -84.15, -821.05, 36.03, 340.96 }
         },
    },
    [4] = { ["name"] = "gigante", ["payment"] = false, ["perm"] = false, ["publica"] = true, ['nameGarage'] = "Garagem de Paleto", -- GARAGEM DE PALETO 
         ["entrada"] = {
            ["blip"] = { 147.85, 6362.94, 31.53 },
            ["veiculo"] = { 136.92, 6367.38, 31.38, 86.05 }
        },
    },
    [5] = { ["name"] = "garage_centro", ["payment"] = false, ["perm"] = false, ["publica"] = true, ['nameGarage'] = "Garagem do centro", -- GARAGEM DO CENTRO
        ["entrada"] = {
            ["blip"] = { -144.43, -577.19, 32.43 },
            ["veiculo"] = { -144.43, -577.19, 32.43, 161.49 }
        },
    },



    -- GARAGEM DE NUI PUBLICA

    [6] = { ['x'] = 100.53, ['y'] = -1073.31, ['z'] = 29.38, ['name'] = "publica",
        [1] = { ['x'] = 104.56, ['y'] = -1078.29, ['z'] = 29.2, ['h'] = 338.39697265625 }
    },
    [7] = { ['x'] = -349.23, ['y'] = -874.14, ['z'] = 31.32, ['name'] = "publica",
        [1] = { ['x'] = -343.47, ['y'] = -875.04, ['z'] = 31.08, ['h'] = 168.21 }
    },
    [8] = { ['x'] = -2030.67, ['y'] = -465.43, ['z'] = 11.61, ['name'] = "publica",
        [1] = { ['x'] = -2037.95, ['y'] = -461.57, ['z'] = 11.39, ['h'] = 318.97 }
    },
    [9] = { ['x'] = 317.92, ['y'] = 2623.45, ['z'] = 44.48, ['name'] = "publica",
        [1] = { ['x'] = 336.29, ['y'] = 2619.81, ['z'] = 44.5, ['h'] = 33.97 }
    },
    [10] = { ['x'] = 1366.11, ['y'] = -1833.8, ['z'] = 57.92, ['name'] = "publica",
        [1] = { ['x'] = 1352.88, ['y'] = -1843.76, ['z'] = 57.14, ['h'] = 289.73 }
    },
    [11] = { ['x'] = -340.8, ['y'] = 266.48, ['z'] = 85.68, ['name'] = "publica",
        [1] = { ['x'] = -349.97, ['y'] = 272.56, ['z'] = 85.07, ['h'] = 270.06 }
    },
    

  --#############################[GARAGEM DAS CASAS]######################################--  
    [268] = { ['name'] = "LS01", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1291.5, -581.39, 71.07, 343.16 },
            ["veiculo"] = { 1291.5, -581.39, 71.07, 343.16 }
        },
        ["interior"] = "media"
    },
    [269] = { ['name'] = "LS02", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1313.03, -588.8, 72.26, 333.16 },
            ["veiculo"] = { 1313.03, -588.8, 72.26, 333.16 }
        },
        ["interior"] = "media"
    },
    [270] = { ['name'] = "LS03", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1347.08, -606.59, 73.68, 320.16 },
            ["veiculo"] = { 1347.08, -606.59, 73.68, 320.16 }
        },
        ["interior"] = "media"
    },
    [271] = { ['name'] = "LS04", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1360.02, -616.33, 73.67, 0.46 },
            ["veiculo"] = { 1360.02, -616.33, 73.67, 0.46 }
        },
        ["interior"] = "media"
    },
    [272] = { ['name'] = "LS05", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1389.82, -605.84, 73.66, 51.10 },
            ["veiculo"] = { 1389.82, -605.84, 73.66, 51.10  }
        },
        ["interior"] = "media"
    },
    [273] = { ['name'] = "LS06", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1401.54, -571.54, 73.67,113,72 },
            ["veiculo"] = { 1401.54, -571.54, 73.67,113,72  }
        },
        ["interior"] = "media"
    },
    [274] = { ['name'] = "LS07", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1365.42, -547.71, 73.66, 157.61 },
            ["veiculo"] = { 1365.42, -547.71, 73.66, 157.61  }
        },
        ["interior"] = "media"
    },
    [275] = { ['name'] = "LS08", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1358.57, -540.4, 73.1, 157.61 },
            ["veiculo"] = { 1358.57, -540.4, 73.1, 157.61  }
        },
        ["interior"] = "media"
    },
    [276] = { ['name'] = "LS09", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1320.28, -528.45, 71.45, 162.76 },
            ["veiculo"] = { 1320.28, -528.45, 71.45, 162.76 }
        },
        ["interior"] = "media"
    },
    [277] = { ['name'] = "LS10", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1313.57, -520.24, 70.64, 163.76 },
            ["veiculo"] = { 1313.57, -520.24, 70.64, 163.76 }
        },
        ["interior"] = "media"
    },
    [278] = { ['name'] = "FH01", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -861.31, 462.66, 86.93, 276.73 },
            ["veiculo"] = { -861.31, 462.66, 86.93, 276.73 }
        },
        ["interior"] = "media"
    },
    [279] = { ['name'] = "FH04", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -851.05, 514.29, 90.15,106.56 },
            ["veiculo"] = { -851.05, 514.29, 90.15,106.56 }
        },
        ["interior"] = "media"
    },
    [280] = { ['name'] = "FH11", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -942.71, 443.81, 79.99,198.88 },
            ["veiculo"] = { -942.71, 443.81, 79.99,198.88 }
        },
        ["interior"] = "media"
    },
    [281] = { ['name'] = "FH15", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1079.10, 465.49, 76.79,144.79 },
            ["veiculo"] = { -1079.10, 465.49, 76.79,144.79 }
        },
        ["interior"] = "media"
    },
    [282] = { ['name'] = "FH19", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -967.03, 450.03, 78.97,199.58 },
            ["veiculo"] = { -967.03, 450.03, 78.97,199.58 }
        },
        ["interior"] = "media"
    },
    [283] = { ['name'] = "FH23", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -736.19, 446.59, 105.88,3.21 },
            ["veiculo"] = { -736.19, 446.59, 105.88,3.21 }
        },
        ["interior"] = "media"
    },
    [284] = { ['name'] = "FH24", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -716.94, 495.36, 108.43,206.78  },
            ["veiculo"] = { -716.94, 495.36, 108.43,206.78  }
        },
        ["interior"] = "media"
    },
    [285] = { ['name'] = "FH26", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -688.85, 500.77, 109.21,201.51 },
            ["veiculo"] = { -688.85, 500.77, 109.21,201.51 }
        },
        ["interior"] = "media"
    },
    [286] = { ['name'] = "FH29", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -573.79, 498.15, 105.38,9.46 },
            ["veiculo"] = { -573.79, 498.15, 105.38,9.46 }
        },
        ["interior"] = "media"
    },
    [287] = { ['name'] = "FH31", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -586.67, 526.68, 106.72,215.41 },
            ["veiculo"] = { -586.67, 526.68, 106.72,215.41 }
        },
        ["interior"] = "media"
    },
    [288] = { ['name'] = "FH32", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -574.73, 401.65, 99.82,19.61 },
            ["veiculo"] = { -574.73, 401.65, 99.82,19.61 }
        },
        ["interior"] = "media"
    },
    [289] = { ['name'] = "FH45", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -456.49, 372.48, 103.93,358.58 },
            ["veiculo"] = { -456.49, 372.48, 103.93,358.58 }
        },
        ["interior"] = "media"
    },
    [290] = { ['name'] = "FH48", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -526.66, 530.68, 110.95,44.11 },
            ["veiculo"] = { -526.66, 530.68, 110.95,44.11 }
        },
        ["interior"] = "media"
    },
    [291] = { ['name'] = "FH49", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -519.47, 574.05, 120.61,281.57 },
            ["veiculo"] = { -519.47, 574.05, 120.61,281.57 }
        },
        ["interior"] = "media"
    },
    [292] = { ['name'] = "FH52", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -468.04, 542.62, 119.92,355.06 },
            ["veiculo"] = { -468.04, 542.62, 119.92,355.06 }
        },
        ["interior"] = "media"
    },
    [293] = { ['name'] = "FH54", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -398.63, 518.94, 119.68,355.21 },
            ["veiculo"] = { -398.63, 518.94, 119.68,355.21 }
        },
        ["interior"] = "media"
    },
    [294] = { ['name'] = "FH55", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -351.33, 474.70, 111.89,299.59 },
            ["veiculo"] = { -351.33, 474.70, 111.89,299.59 }
        },
        ["interior"] = "media"
    },
    [295] = { ['name'] = "FH58", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -362.62, 514.72, 118.67,134.89 },
            ["veiculo"] = { -362.62, 514.72, 118.67,134.89 }
        },
        ["interior"] = "media"
    },
    [296] = { ['name'] = "FH59", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -320.42, 480.85, 111.44,118.55 },
            ["veiculo"] = { -320.42, 480.85, 111.44,118.55 }
        },
        ["interior"] = "media"
    },
    [297] = { ['name'] = "FH68", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1376.73, 453.26, 104.04,80.28 },
            ["veiculo"] = { -1376.73, 453.26, 104.04,80.28 }
        },
        ["interior"] = "media"
    },
    [298] = { ['name'] = "FH81", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -467.37, 673.46, 146.80,148.40 },
            ["veiculo"] = { -467.37, 673.46, 146.80,148.40 }
        },
        ["interior"] = "media"
    },
    [299] = { ['name'] = "FH91", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -958.62, 800.59, 176.76,152.94 },
            ["veiculo"] = { -958.62, 800.59, 176.76,152.94 }
        },
        ["interior"] = "media"
    },
    [300] = { ['name'] = "FH92", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -920.00, 806.38, 183.37,189.06 },
            ["veiculo"] = { -920.00, 806.38, 183.37,189.06 }
        },
        ["interior"] = "media"
    },
    [301] = { ['name'] = "FH93", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -997.95, 786.76, 171.06,293.50 },
            ["veiculo"] = { -997.95, 786.76, 171.06,293.50 }
        },
        ["interior"] = "media"
    },
    [302] = { ['name'] = "FH94", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -811.60, 809.51, 201.24,19.71 },
            ["veiculo"] = { -811.60, 809.51, 201.24,19.71 }
        },
        ["interior"] = "media"
    },
    [303] = { ['name'] = "LX01", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -869.45, -54.25, 37.60,281.38 },
            ["veiculo"] = { -869.45, -54.25, 37.60,281.38 }
        },
        ["interior"] = "grande"
    },
    [304] = { ['name'] = "LX02", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -885.98, -16.18, 42.15,304.12 },
            ["veiculo"] = { -885.98, -16.18, 42.15,304.12 }
        },
        ["interior"] = "grande"
    },
    [305] = { ['name'] = "LX03", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -875.02, 46.86, 48.39,195.46 },
            ["veiculo"] = { -875.02, 46.86, 48.39,195.46 }
        },
        ["interior"] = "grande"
    },
    [306] = { ['name'] = "LX04", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -960.77, 109.36, 55.49,314.26 },
            ["veiculo"] = { -960.77, 109.36, 55.49,314.26 }
        },
        ["interior"] = "grande"
    },
    [307] = { ['name'] = "LX05", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1890.51, 626.00, 129.15,136.16 },
            ["veiculo"] = { -1890.51, 626.00, 129.15,136.16 }
        },
        ["interior"] = "grande"
    },
    [308] = { ['name'] = "LX06", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -992.02, 144.19, 59.81,269.99 },
            ["veiculo"] = { -992.02, 144.19, 59.81,269.99 }
        },
        ["interior"] = "grande"
    },
    [309] = { ['name'] = "LX07", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1049.29, -493.48, 63.91,265.95 },
            ["veiculo"] = { 1048.79, -486.96, 63.83,184.73 }
        },
        ["interior"] = "grande"
    },
    [310] = { ['name'] = "LX08", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -933.57, 210.69, 66.61,163.52 },
            ["veiculo"] = { -933.57, 210.69, 66.61,163.52 }
        },
        ["interior"] = "grande"
    },
    [311] = { ['name'] = "LX09", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -911.78, 190.68, 68.59,179.92 },
            ["veiculo"] = { -911.78, 190.68, 68.59,179.92 }
        },
        ["interior"] = "grande"
    },
    [312] = { ['name'] = "LX10", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -920.41, 112.49, 54.47,84.90 },
            ["veiculo"] = { -920.41, 112.49, 54.47,84.90 }
        },
        ["interior"] = "grande"
    },
    [313] = { ['name'] = "LX11", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -925.27, 9.31, 46.87,214.83 },
            ["veiculo"] = { -925.27, 9.31, 46.87,214.83 }
        },
        ["interior"] = "grande"
    },
    [314] = { ['name'] = "LX12", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -839.12, 112.30, 54.43,210.36 },
            ["veiculo"] = { -839.12, 112.30, 54.43,210.36 }
        },
        ["interior"] = "grande"
    },
    [315] = { ['name'] = "LX13", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1061.49, 305.25, 65.13,353.81 },
            ["veiculo"] = { -1061.49, 305.25, 65.13,353.81 }
        },
        ["interior"] = "grande"
    },
    [316] = { ['name'] = "LX14", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -824.72, 273.44, 85.68,342.78 },
            ["veiculo"] = { -824.72, 273.44, 85.68,342.78 }
        },
        ["interior"] = "grande"
    },
    [317] = { ['name'] = "LX15", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -870.29, 317.83, 83.13,186.23 },
            ["veiculo"] = { -870.29, 317.83, 83.13,186.23 }
        },
        ["interior"] = "grande"
    },
    [318] = { ['name'] = "LX16", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -888.36, 367.35, 84.55,3.40 },
            ["veiculo"] = { -888.36, 367.35, 84.55,3.40 }
        },
        ["interior"] = "grande"
    },
    [319] = { ['name'] = "LX17", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1011.08, 360.01, 70.05,331.43 },
            ["veiculo"] = { -1011.08, 360.01, 70.05,331.43 }
        },
        ["interior"] = "grande"
    },
    [320] = { ['name'] = "LX18", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1547.98, 426.58, 109.09,272.82 },
            ["veiculo"] = { -1547.98, 426.58, 109.09,272.82 }
        },
        ["interior"] = "grande"
    },
    [321] = { ['name'] = "LX19", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1204.83, 267.12, 68.69,284.35 },
            ["veiculo"] = { -1204.83, 267.12, 68.69,284.35 }
        },
        ["interior"] = "grande"
    },
    [322] = { ['name'] = "LX20", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1096.63, 360.30, 67.69,357.45 },
            ["veiculo"] = { -1096.63, 360.30, 67.69,357.45 }
        },
        ["interior"] = "grande"
    },
    [323] = { ['name'] = "LX21", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1490.16, 23.07, 53.88,354.88 },
            ["veiculo"] = { -1490.16, 23.07, 53.88,354.88 }
        },
        ["interior"] = "grande"
    },
    [324] = { ['name'] = "LX22", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1455.68, -55.37, 52.6,240.6 },
            ["veiculo"] = { -1455.68, -55.37, 52.6,240.6 }
        },
        ["interior"] = "grande"
    },
    [325] = { ['name'] = "LX23", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1503.75, 26.86, 55.15,8.38 },
            ["veiculo"] = { -1503.75, 26.86, 55.15,8.38 }
        },
        ["interior"] = "grande"
    },
    [326] = { ['name'] = "LX24", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1577.19, -86.02, 53.29,270.66 },
            ["veiculo"] = { -1577.19, -86.02, 53.29,270.66 }
        },
        ["interior"] = "grande"
    },
    [327] = { ['name'] = "LX25", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1582.02, -61.06, 55.64,270.18 },
            ["veiculo"] = { -1582.02, -61.06, 55.64,270.18 }
        },
        ["interior"] = "grande"
    },
    [328] = { ['name'] = "LX26", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1552.69, 22.78, 57.70,347.50 },
            ["veiculo"] = { -1552.69, 22.78, 57.70,347.50 }
        },
        ["interior"] = "grande"
    },
    [329] = { ['name'] = "LX27", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1613.07, 20.02, 61.32,335.94 },
            ["veiculo"] = { -1613.07, 20.02, 61.32,335.94 }
        },
        ["interior"] = "grande"
    },
    [330] = { ['name'] = "LX28", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1887.23, 123.26, 80.86,338.84 },
            ["veiculo"] = { -1887.23, 123.26, 80.86,338.84 }
        },
        ["interior"] = "grande"
    },
    [331] = { ['name'] = "LX29", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1932.93, 182.84, 83.68,307.83 },
            ["veiculo"] = { -1932.93, 182.84, 83.68,307.83 }
        },
        ["interior"] = "grande"
    },
    [332] = { ['name'] = "LX32", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1994.21, 290.29, 90.85,221.21 },
            ["veiculo"] = { -1994.21, 290.29, 90.85,221.21 }
        },
        ["interior"] = "grande"
    },
    [333] = { ['name'] = "LX34", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -2006.95, 454.86, 101.79,276.63 },
            ["veiculo"] = { -2006.95, 454.86, 101.79,276.63 }
        },
        ["interior"] = "grande"
    },
    [334] = { ['name'] = "LX35", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -2011.39, 482.71, 106.07,255.38 },
            ["veiculo"] = { -2011.39, 482.71, 106.07,255.38 }
        },
        ["interior"] = "grande"
    },
    [335] = { ['name'] = "LX36", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1874.17, 194.45, 83.77,126.46 },
            ["veiculo"] = { -1874.17, 194.45, 83.77,126.46 }
        },
        ["interior"] = "grande"
    },
    [336] = { ['name'] = "LX37", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1904.45, 242.14, 85.6,27.89 },
            ["veiculo"] = { -1904.45, 242.14, 85.6,27.89 }
        },
        ["interior"] = "grande"
    },
    [337] = { ['name'] = "LX38", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1925.28, 283.01, 88.23,182.84 },
            ["veiculo"] = { -1925.28, 283.01, 88.23,182.84 }
        },
        ["interior"] = "grande"
    },
    [338] = { ['name'] = "LX39", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1940.58, 360.31, 92.55,160.68 },
            ["veiculo"] = { -1940.58, 360.31, 92.55,160.68 }
        },
        ["interior"] = "grande"
    },
    [339] = { ['name'] = "LX40", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1943.95, 385.19, 95.60,96.89 },
            ["veiculo"] = { -1943.95, 385.19, 95.60,96.89 }
        },
        ["interior"] = "grande"
    },
    [340] = { ['name'] = "LX41", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1947.37, 462.90, 101.12,99.05 },
            ["veiculo"] = { -1947.37, 462.90, 101.12,99.05 }
        },
        ["interior"] = "grande"
    },
    [341] = { ['name'] = "LX42", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1857.45, 328.42, 87.80,11.41 },
            ["veiculo"] = { -1857.45, 328.42, 87.80,11.41 }
        },
        ["interior"] = "grande"
    },
    [342] = { ['name'] = "LX43", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1790.72, 353.87, 87.72,64.22 },
            ["veiculo"] = { -1790.72, 353.87, 87.72,64.22 }
        },
        ["interior"] = "grande"
    },
    [343] = { ['name'] = "LX44", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1750.77, 365.56, 88.85,114.91 },
            ["veiculo"] = { -1750.77, 365.56, 88.85,114.91 }
        },
        ["interior"] = "grande"
    },
    [344] = { ['name'] = "LX45", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1663.42, 391.43, 88.39,9.57 },
            ["veiculo"] = { -1663.42, 391.43, 88.39,9.57 }
        },
        ["interior"] = "grande"
    },
    [345] = { ['name'] = "LX46", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1794.11, 459.40, 127.46,98.09 },
            ["veiculo"] = { -1794.11, 459.40, 127.46,98.09 }
        },
        ["interior"] = "grande"
    },
    [346] = { ['name'] = "LX47", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1985.63, 602.72, 117.28,238.48 },
            ["veiculo"] = { -1985.63, 602.72, 117.28,238.48 }
        },
        ["interior"] = "grande"
    },
    [347] = { ['name'] = "LX48", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1944.07, 521.99, 108.31,71.00 },
            ["veiculo"] = { -1944.07, 521.99, 108.31,71.00 }
        },
        ["interior"] = "grande"
    },

    [348] = { ['name'] = "LX50", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1971.35, 620.69, 121.14,246.10 },
            ["veiculo"] = { -1971.35, 620.69, 121.14,246.10 }
        },
        ["interior"] = "grande"
    },
    [349] = { ['name'] = "LX51", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -162.36, 926.68, 234.80,234.16 },
            ["veiculo"] = { -162.36, 926.68, 234.80,234.16 }
        },
        ["interior"] = "grande"
    },
    [350] = { ['name'] = "LX52", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -167.03, 970.73, 235.79,316.56 },
            ["veiculo"] = { -167.03, 970.73, 235.79,316.56 }
        },
        ["interior"] = "grande"
    },
    [351] = { ['name'] = "LX53", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -127.89, 1001.16, 234.88,198.68 },
            ["veiculo"] = { -127.89, 1001.16, 234.88,198.68 }
        },
        ["interior"] = "grande"
    },
    [352] = { ['name'] = "LX54", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -105.63, 832.61, 234.86,10.25 },
            ["veiculo"] = { -105.63, 832.61, 234.86,10.25 }
        },
        ["interior"] = "grande"
    },
    [353] = { ['name'] = "LX55", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 215.84, 759.38, 203.83,47.56 },
            ["veiculo"] = { 215.84, 759.38, 203.83,47.56 }
        },
        ["interior"] = "grande"
    },
    [354] = { ['name'] = "LX58", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 93.13, 575.77, 182.13,86.85 },
            ["veiculo"] = { 93.13, 575.77, 182.13,86.85 }
        },
        ["interior"] = "grande"
    },
    [355] = { ['name'] = "LX59", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 53.19, 563.71, 179.54,21.70 },
            ["veiculo"] = { 53.19, 563.71, 179.54,21.70 }
        },
        ["interior"] = "grande"
    },
    [356] = { ['name'] = "LX60", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -142.21, 597.23, 203.12,358.34 },
            ["veiculo"] = { -142.21, 597.23, 203.12,358.34 }
        },
        ["interior"] = "grande"
    },
    [357] = { ['name'] = "LX61", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -199.24, 615.31, 196.21,178.98 },
            ["veiculo"] = { -199.24, 615.31, 196.21,178.98 }
        },
        ["interior"] = "grande"
    },
    [358] = { ['name'] = "LX62", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -178.23, 587.21, 197.03,359.63 },
            ["veiculo"] = { -178.23, 587.21, 197.03,359.63 }
        },
        ["interior"] = "grande"
    },
    [359] = { ['name'] = "LX63", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -221.77, 593.25, 189.61,331.22 },
            ["veiculo"] = { -221.77, 593.25, 189.61,331.22 }
        },
        ["interior"] = "grande"
    },
    [360] = { ['name'] = "LX64", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -272.26, 603.60, 181.15,346.60 },
            ["veiculo"] = { -272.26, 603.60, 181.15,346.60 }
        },
        ["interior"] = "grande"
    },
    [361] = { ['name'] = "LX65", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -244.12, 610.79, 186.09,149.22 },
            ["veiculo"] = { -244.12, 610.79, 186.09,149.22 }
        },
        ["interior"] = "grande"
    },
    [362] = { ['name'] = "LX66", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -343.97, 634.83, 171.43,52.04 },
            ["veiculo"] = { -343.97, 634.83, 171.43,52.04 }
        },
        ["interior"] = "grande"
    },
    [363] = { ['name'] = "LX67", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 316.29, 568.06, 153.55,220.69 },
            ["veiculo"] = { 316.29, 568.06, 153.55,220.69 }
        },
        ["interior"] = "grande"
    },
    [364] = { ['name'] = "LX68", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 321.07, 494.12, 151.61,283.10 },
            ["veiculo"] = { 321.07, 494.12, 151.61,283.10 }
        },
        ["interior"] = "grande"
    },
    [365] = { ['name'] = "LX69", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 330.37, 482.12, 149.86,195.82 },
            ["veiculo"] = { 330.37, 482.12, 149.86,195.82 }
        },
        ["interior"] = "grande"
    },
    [366] = { ['name'] = "LX70", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 236.21, 536.62, 139.88,114.71 },
            ["veiculo"] = { 236.21, 536.62, 139.88,114.71 }
        },
        ["interior"] = "grande"
    },
    [368] = { ['name'] = "MS01", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 14.98, 549.89, 175.50,60.70 },
            ["veiculo"] = { 14.98, 549.89, 175.50,60.70 }
        },
        ["interior"] = "grande"
    },
        [367] = { ['name'] = "LX49", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1941.31, 582.04, 118.92, 251.28 },
            ["veiculo"] = { -1941.31, 582.04, 118.92, 251.28 }
        },
        ["interior"] = "grande"
    },
    [369] = { ['name'] = "MS02", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -821.16, 185.31, 71.25,119.13 },
            ["veiculo"] = { -821.16, 185.31, 71.25,119.13 }
        },
        ["interior"] = "grande"
    },
    [370] = { ['name'] = "MS03", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -675.44, 903.59, 229.73,326.35 },
            ["veiculo"] = { -675.44, 903.59, 229.73,326.35 }
        },
        ["interior"] = "grande"
    },
    [371] = { ['name'] = "MS04", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -2588.73, 1929.85, 166.46,275.01 },
            ["veiculo"] = { -2588.73, 1929.85, 166.46,275.01 }
        },
        ["interior"] = "grande"
    },
    [372] = { ['name'] = "MS05", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -3019.92, 740.24, 26.63,103.34 },
            ["veiculo"] = { -3019.92, 740.24, 26.63,103.34 }
        },
        ["interior"] = "grande"
    },
    [373] = { ['name'] = "MS06", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -3001.45, 702.15, 26.9,110.47 },
            ["veiculo"] = { -3001.45, 702.15, 26.9,110.47 }
        },
        ["interior"] = "grande"
    },
    [374] = { ['name'] = "MS09", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -1886.63, -571.43, 10.93,319.54 },
            ["veiculo"] = { -1886.63, -571.43, 10.93,319.54 }
        },
        ["interior"] = "grande"
    },
    [375] = { ['name'] = "SS01", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 1554.26, 2196.07, 78.5,352.11 },
            ["veiculo"] = { 1554.26, 2196.07, 78.5,352.11 }
        },
        ["interior"] = "grande"
    },
    [376] = { ['name'] = "MS08", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { -2982.74, 654.65, 25.015,106.83 },
            ["veiculo"] = { -2982.74, 654.65, 25.015,106.83 }
        },
        ["interior"] = "grande"
    },
     [377] = { ['name'] = "ML02", ['payment'] = false, ['perm'] = false,
         ["entrada"] = {
             ["blip"] = { -1985.43, -496.57, 12.18 },
             ["veiculo"] = { -1975.79, -492.75, 12.1, 320.63 }
         },
         ["interior"] = "grande"
     },
    [378] = { ['name'] = "RA01", ['payment'] = false, ['perm'] = false,
         ["entrada"] = {
             ["blip"] = { -1531.45, 889.88, 181.88,21.71 },
             ["veiculo"] = { -1531.45, 889.88, 181.88,21.71 }
         },
         ["interior"] = "grande"
     }, 
    [379] = { ['name'] = "ML11", ['payment'] = false, ['perm'] = false,
         ["entrada"] = {
             ["blip"] = { -3060.73, 3470.08, 6.6 },
             ["veiculo"] = { -3060.73, 3470.08, 6.6, 126.63 }
        },
         ["interior"] = "grande"
    },

    [387] = { ['x'] = 102.82, ['y'] = -1959.78, ['z'] = 20.84, ['name'] = "KR01",
        [1] = { ['x'] = 104.57, ['y'] = -1954.94, ['z'] = 20.95, ['h'] = 355.58 }
    },
    [388] = { ['x'] = 72.16, ['y'] = -1935.47, ['z'] = 20.99, ['name'] = "KR02",
        [1] = { ['x'] = 81.72, ['y'] = -1932.41, ['z'] = 21.02, ['h'] = 316.63 }
    },
    [389] = { ['x'] = 14.13, ['y'] = -1886.93, ['z'] = 23.24, ['name'] = "KR03",
        [1] = { ['x'] = 18.48, ['y'] = -1880.11, ['z'] = 23.28, ['h'] = 320.5 }
    }, 
    [390] = { ['x'] = 98.75, ['y'] = -1907.55, ['z'] = 21.07, ['name'] = "KR04",
        [1] = { ['x'] = 89.81, ['y'] = -1917.18, ['z'] = 20.98, ['h'] = 140.59 }
    },
    [391] = { ['x'] = 101.95, ['y'] = -1883.62, ['z'] = 24.02, ['name'] = "KR05",
        [1] = { ['x'] = 105.76, ['y'] = -1879.36, ['z'] = 24.22, ['h'] = 319.71 }
    },
    [392] = { ['x'] = 157.6, ['y'] = -1901.16, ['z'] = 23.0, ['name'] = "KR06",
        [1] = { ['x'] = 162.82, ['y'] = -1899.28, ['z'] = 23.26, ['h'] = 334.81 }
    },
    [393] = { ['x'] = 163.9, ['y'] = -1954.67, ['z'] = 19.32, ['name'] = "KR07",
        [1] = { ['x'] = 165.73, ['y'] = -1959.08, ['z'] = 19.43, ['h'] = 227.78 }
    },
    [394] = { ['x'] = 152.53, ['y'] = -1960.61, ['z'] = 19.08, ['name'] = "KR08",
        [1] = { ['x'] = 152.79, ['y'] = -1965.88, ['z'] = 19.04, ['h'] = 228.5 }
    },
    [395] = { ['x'] = 58.69, ['y'] = -1878.41, ['z'] = 22.39, ['name'] = "KR09",
        [1] = { ['x'] = 52.14, ['y'] = -1878.42, ['z'] = 22.53, ['h'] = 136.83 }
    },
    [396] = { ['x'] = 45.4, ['y'] = -1849.13, ['z'] = 22.84, ['name'] = "KR10",
        [1] = { ['x'] = 41.44, ['y'] = -1853.34, ['z'] = 23.11, ['h'] = 135.2 }
    },
    [397] = { ['x'] = -45.22, ['y'] = -1791.79, ['z'] = 27.45, ['name'] = "KR11",
        [1] = { ['x'] = -53.0, ['y'] = -1801.42, ['z'] = 27.36, ['h'] = 50.04 }
    },
    [398] = { ['x'] = -54.09, ['y'] = -1781.86, ['z'] = 27.88, ['name'] = "KR12",
        [1] = { ['x'] = -57.67, ['y'] = -1785.85, ['z'] = 28.12, ['h'] = 136.73 }
    },
    [399] = { ['x'] = 140.35, ['y'] = -1866.11, ['z'] = 24.32, ['name'] = "KR13",
        [1] = { ['x'] = 136.94, ['y'] = -1869.3, ['z'] = 24.4, ['h'] = 155.02 }
    },
    [400] = { ['x'] = 189.37, ['y'] = -1872.27, ['z'] = 24.73, ['name'] = "KR14",
        [1] = { ['x'] = 186.58, ['y'] = -1877.13, ['z'] = 24.85, ['h'] = 154.49 }
    },
    [401] = { ['x'] = 248.21, ['y'] = -1732.71, ['z'] = 29.38, ['name'] = "KR15",
        [1] = { ['x'] = 244.51, ['y'] = -1728.83, ['z'] = 29.5, ['h'] = 49.0 }
    },
    [402] = { ['x'] = 272.34, ['y'] = -1704.01, ['z'] = 29.31, ['name'] = "KR16",
        [1] = { ['x'] = 268.09, ['y'] = -1700.73, ['z'] = 29.57, ['h'] = 49.31 }
    },
    [403] = { ['x'] = 291.46, ['y'] = -1783.92, ['z'] = 28.26, ['name'] = "KR17",
        [1] = { ['x'] = 297.45, ['y'] = -1791.53, ['z'] = 28.19, ['h'] = 228.58 }
    },
    [404] = { ['x'] = 319.33, ['y'] = -1769.51, ['z'] = 29.08, ['name'] = "KR18",
        [1] = { ['x'] = 321.52, ['y'] = -1773.31, ['z'] = 28.93, ['h'] = 229.23 }
    },
    [405] = { ['x'] = 142.93, ['y'] = -1832.74, ['z'] = 27.07, ['name'] = "KR19",
        [1] = { ['x'] = 138.97, ['y'] = -1830.69, ['z'] = 27.29, ['h'] = 49.32 }
    },
    [406] = { ['x'] = 83.64, ['y'] = -1973.9, ['z'] = 20.93, ['name'] = "KR20",
        [1] = { ['x'] = 87.72, ['y'] = -1968.8, ['z'] = 21.03, ['h'] = 319.25 }
    },
    [407] = { ['x'] = 80.39, ['y'] = -1949.55, ['z'] = 20.8, ['name'] = "KR21",
        [1] = { ['x'] = 89.19, ['y'] = -1934.65, ['z'] = 20.91, ['h'] = 217.76 }
    },
    [408] = { ['x'] = 54.53, ['y'] = -1921.05, ['z'] = 21.66, ['name'] = "KR22",
        [1] = { ['x'] = 62.29, ['y'] = -1910.55, ['z'] = 21.78, ['h'] = 230.76 }
    },
    [409] = { ['x'] = 37.3, ['y'] = -1926.34, ['z'] = 21.8, ['name'] = "KR23",
        [1] = { ['x'] = 42.47, ['y'] = -1920.65, ['z'] = 21.94, ['h'] = 320.78 }
    },
    [410] = { ['x'] = -10.49, ['y'] = -1883.78, ['z'] = 24.15, ['name'] = "KR24",
        [1] = { ['x'] = 0.4, ['y'] = -1878.23, ['z'] = 23.07, ['h'] = 319.84 }
    },
    [411] = { ['x'] = 9.54, ['y'] = -1883.11, ['z'] = 23.32, ['name'] = "KR25",
        [1] = { ['x'] = 15.62, ['y'] = -1871.47, ['z'] = 23.56, ['h'] = 228.24 }
    },
    [412] = { ['x'] = -23.09, ['y'] = -1857.7, ['z'] = 25.04, ['name'] = "KR26",
        [1] = { ['x'] = -22.28, ['y'] = -1852.32, ['z'] = 25.35, ['h'] = 318.16 }
    },
    [413] = { ['x'] = -33.91, ['y'] = -1855.64, ['z'] = 26.01, ['name'] = "KR27",
        [1] = { ['x'] = -36.14, ['y'] = -1861.29, ['z'] = 26.03, ['h'] = 318.25 }
    },
    [414] = { ['x'] = 123.49, ['y'] = -1927.1, ['z'] = 21.01, ['name'] = "KR28",
        [1] = { ['x'] = 118.66, ['y'] = -1940.02, ['z'] = 20.95, ['h'] = 86.06 }
    },
    [415] = { ['x'] = 116.48, ['y'] = -1918.75, ['z'] = 20.94, ['name'] = "KR29",
        [1] = { ['x'] = 109.49, ['y'] = -1924.84, ['z'] = 21.03, ['h'] = 159.44 }
    },
    [416] = { ['x'] = 112.4, ['y'] = -1884.8, ['z'] = 23.59, ['name'] = "KR30",
        [1] = { ['x'] = 125.42, ['y'] = -1877.96, ['z'] = 23.98, ['h'] = 245.04 }
    },
    [417] = { ['x'] = 163.74, ['y'] = -1922.7, ['z'] = 21.2, ['name'] = "KR31",
        [1] = { ['x'] = 166.25, ['y'] = -1929.66, ['z'] = 21.29, ['h'] = 230.07 }
    },
    [418] = { ['x'] = 142.93, ['y'] = -1970.81, ['z'] = 18.86, ['name'] = "KR32",
        [1] = { ['x'] = 153.95, ['y'] = -1978.59, ['z'] = 18.55, ['h'] = 139.63 }
    },
    [419] = { ['x'] = 28.49, ['y'] = -1852.1, ['z'] = 23.68, ['name'] = "KR33",
        [1] = { ['x'] = 20.42, ['y'] = -1863.32, ['z'] = 23.63, ['h'] = 50.07 }
    },
    [420] = { ['x'] = 11.84, ['y'] = -1843.19, ['z'] = 24.53, ['name'] = "KR34",
        [1] = { ['x'] = 8.43, ['y'] = -1845.9, ['z'] = 24.64, ['h'] = 139.44 }
    }, 
    [421] = { ['x'] = 167.84, ['y'] = -1854.07, ['z'] = 24.29, ['name'] = "KR35",
        [1] = { ['x'] = 165.62, ['y'] = -1861.16, ['z'] = 24.41, ['h'] = 155.81 }
    },
    [422] = { ['x'] = 206.99, ['y'] = -1892.89, ['z'] = 24.43, ['name'] = "KR36",
        [1] = { ['x'] = 198.9, ['y'] = -1897.55, ['z'] = 24.5, ['h'] = 142.92 }
    },
    [423] = { ['x'] = 302.56, ['y'] = -1777.35, ['z'] = 29.1, ['name'] = "KR37",
        [1] = { ['x'] = 312.42, ['y'] = -1785.76, ['z'] = 28.42, ['h'] = 229.27 }
    },
    [424] = { ['x'] = 289.96, ['y'] = -1789.91, ['z'] = 27.7, ['name'] = "KR38",
        [1] = { ['x'] = 297.45, ['y'] = -1791.53, ['z'] = 28.19, ['h'] = 228.58 }
    },
    [425] = { ['x'] = 311.04, ['y'] = -1735.44, ['z'] = 29.54, ['name'] = "KR39",
        [1] = { ['x'] = 315.43, ['y'] = -1739.08, ['z'] = 29.73, ['h'] = 231.04 }
    },
    [426] = { ['x'] = 269.11, ['y'] = -1728.64, ['z'] = 29.65, ['name'] = "KR40",
        [1] = { ['x'] = 264.26, ['y'] = -1718.68, ['z'] = 29.56, ['h'] = 49.25 }
    },
    [427] = { ['x'] = 269.79, ['y'] = -1710.52, ['z'] = 29.34, ['name'] = "KR41",
        [1] = { ['x'] = 257.55, ['y'] = -1701.71, ['z'] = 29.31, ['h'] = 320.02 }
    },
    [428] = { ['x'] = 248.94, ['y'] = -1936.94, ['z'] = 24.35, ['name'] = "LV01",
        [1] = { ['x'] = 240.16, ['y'] = -1927.99, ['z'] = 24.39, ['h'] = 319.70 }
    },
    [429] = { ['x'] = 269.8, ['y'] = -1932.86, ['z'] = 25.44, ['name'] = "LV02",
        [1] = { ['x'] = 267.71, ['y'] = -1925.64, ['z'] = 25.52, ['h'] = 47.52 }
    },
    [430] = { ['x'] = 270.61, ['y'] = -1914.8, ['z'] = 25.81, ['name'] = "LV03",
        [1] = { ['x'] = 270.12, ['y'] = -1905.53, ['z'] = 26.78, ['h'] = 51.02 }
    },	
    [431] = { ['x'] = 279.17, ['y'] = -1899.45, ['z'] = 26.89, ['name'] = "LV04", 
        [1] = { ['x'] = 269.73, ['y'] = -1892.82, ['z'] = 26.83, ['h'] = 319.63 }
    },	
    [432] = { ['x'] = 318.07, ['y'] = -1856.29, ['z'] = 27.11, ['name'] = "LV05",
        [1] = { ['x'] = 305.2, ['y'] = -1850.27, ['z'] = 27.0, ['h'] = 320.21 }
    },	
    [433] = { ['x'] = 340.81, ['y'] = -1849.98, ['z'] = 27.77, ['name'] = "LV06",
        [1] = { ['x'] = 335.81, ['y'] = -1835.98, ['z'] = 27.61, ['h'] = 44.87 }
    },	
    [434] = { ['x'] = 344.21, ['y'] = -1828.31, ['z'] = 27.95, ['name'] = "LV07",
        [1] = { ['x'] = 333.16, ['y'] = -1817.23, ['z'] = 27.99, ['h'] = 320.18 }
    },	
    [435] = { ['x'] = 350.15, ['y'] = -1811.51, ['z'] = 28.8, ['name'] = "LV08",
        [1] = { ['x'] = 342.37, ['y'] = -1806.23, ['z'] = 28.48, ['h'] = 319.97 }
    },	
    [436] = { ['x'] = 404.54, ['y'] = -1753.91, ['z'] = 29.37, ['name'] = "LV09",
        [1] = { ['x'] = 403.61, ['y'] = -1739.39, ['z'] = 29.54, ['h'] = 46.70 }
    },	
    [437] = { ['x'] = 430.66, ['y'] = -1741.22, ['z'] = 29.61, ['name'] = "LV10",
        [1] = { ['x'] = 431.33, ['y'] = -1735.54, ['z'] = 28.65, ['h'] = 50.20 }
    },	
    [438] = { ['x'] = 434.96, ['y'] = -1715.43, ['z'] = 29.33, ['name'] = "LV11",
        [1] = { ['x'] = 430.06, ['y'] = -1715.87, ['z'] = 28.69, ['h'] = 49.34 }
    },	
    [439] = { ['x'] = 442.86, ['y'] = -1698.41, ['z'] = 29.38, ['name'] = "LV12",
        [1] = { ['x'] = 442.78, ['y'] = -1693.12, ['z'] = 28.66, ['h'] = 51.33 }
    },	
    [440] = { ['x'] = 498.38, ['y'] = -1698.89, ['z'] = 29.41, ['name'] = "LV13",
        [1] = { ['x'] = 498.01, ['y'] = -1702.77, ['z'] = 29.64, ['h'] = 236.28 }
    },	
    [441] = { ['x'] = 479.02, ['y'] = -1718.03, ['z'] = 29.37, ['name'] = "LV14",
        [1] = { ['x'] = 490.02, ['y'] = -1721.93, ['z'] = 29.62, ['h'] = 251.19 }
    },	
    [442] = { ['x'] = 464.62, ['y'] = -1740.78, ['z'] = 29.11, ['name'] = "LV15",	
        [1] = { ['x'] = 473.8, ['y'] = -1744.08, ['z'] = 29.21,  ['h'] = 250.40 }
    },	
    [443] = { ['x'] = 475.52, ['y'] = -1755.13, ['z'] = 28.76, ['name'] = "LV16",
        [1] = { ['x'] = 488.5, ['y'] = -1757.75, ['z'] = 28.71,  ['h'] = 163.16 }
    },	
    [444] = { ['x'] = 475.02, ['y'] = -1772.84, ['z'] = 28.7, ['name'] = "LV17",
        [1] = { ['x'] = 478.21, ['y'] = -1779.06, ['z'] = 28.93, ['h'] = 270.19 }
    },	
    [445] = { ['x'] = 511.46, ['y'] = -1778.19, ['z'] = 28.51, ['name'] = "LV18",
        [1] = { ['x'] = 499.79, ['y'] = -1777.14, ['z'] = 28.64, ['h'] = 201.67 }
    },	
    [446] = { ['x'] = 504.82, ['y'] = -1799.04, ['z'] = 28.49, ['name'] = "LV19",
        [1] = { ['x'] = 500.19, ['y'] = -1792.86, ['z'] = 28.65, ['h'] = 161.09 }
    },	
    [447] = { ['x'] = 504.77, ['y'] = -1808.65, ['z'] = 28.51, ['name'] = "LV20",
        [1] = { ['x'] = 491.87, ['y'] = -1805.02, ['z'] = 28.65, ['h'] = 138.92 }
    },	
    [448] = { ['x'] = 487.7, ['y'] = -1826.73, ['z'] = 28.53, ['name'] = "LV21",
        [1] = { ['x'] = 479.28, ['y'] = -1819.72, ['z'] = 28.1,  ['h'] = 139.70 }
    },	
    [449] = { ['x'] = 431.96, ['y'] = -1828.9, ['z'] = 28.18, ['name'] = "LV22",
        [1] = { ['x'] = 437.06, ['y'] = -1837.91, ['z'] = 28.21, ['h'] = 223.26 }
    },	
    [450] = { ['x'] = 428.72, ['y'] = -1839.65, ['z'] = 28.08, ['name'] = "LV23",
        [1] = { ['x'] = 434.57, ['y'] = -1841.14, ['z'] = 28.23, ['h'] = 222.18 }
    },	
    [451] = { ['x'] = 395.08, ['y'] = -1844.77, ['z'] = 26.84, ['name'] = "LV24",
        [1] = { ['x'] = 395.69, ['y'] = -1850.26, ['z'] = 26.2, ['h'] = 223.86 }
    },	
    [452] = { ['x'] = 396.69, ['y'] = -1872.65, ['z'] = 26.25, ['name'] = "LV25",
        [1] = { ['x'] = 397.28, ['y'] = -1877.44, ['z'] = 26.35, ['h'] = 222.91 }
    },	
    [453] = { ['x'] = 385.03, ['y'] = -1890.77, ['z'] = 25.32, ['name'] = "LV26",
        [1] = { ['x'] = 384.63, ['y'] = -1896.36, ['z'] = 25.21, ['h'] = 222.83 }
    },	
    [454] = { ['x'] = 360.06, ['y'] = -1894.9, ['z'] = 24.99, ['name'] = "LV27",
        [1] = { ['x'] = 357.8, ['y'] = -1896.77, ['z'] = 25.08,  ['h'] = 227.00 }
    },	
    [455] = { ['x'] = 315.73, ['y'] = -1937.5, ['z'] = 24.82, ['name'] = "LV28",
        [1] = { ['x'] = 315.5, ['y'] = -1942.05, ['z'] = 24.92,  ['h'] = 230.52 }
    },	
    [456] = { ['x'] = 310.66, ['y'] = -1965.91, ['z'] = 23.74, ['name'] = "LV29",
        [1] = { ['x'] = 316.82, ['y'] = -1970.62, ['z'] = 23.69, ['h'] = 138.57 }
    },	
    [457] = { ['x'] = 299.42, ['y'] = -1971.96, ['z'] = 22.49, ['name'] = "LV30",
        [1] = { ['x'] = 306.82, ['y'] = -1982.39, ['z'] = 22.39, ['h'] = 139.63 }
    },	
    [458] = { ['x'] = 282.89, ['y'] = -1980.29, ['z'] = 21.4 , ['name'] = "LV31",
        [1] = { ['x'] = 285.64, ['y'] = -1985.85, ['z'] = 21.41, ['h'] = 229.16 }
    },	
    [459] = { ['x'] = 280.83, ['y'] = -1991.24, ['z'] = 20.46, ['name'] = "LV32",
        [1] = { ['x'] = 286.37, ['y'] = -1992.54, ['z'] = 20.81, ['h'] = 228.61 }
    },	
    [460] = { ['x'] = 256.42, ['y'] = -2026.71, ['z'] = 18.86, ['name'] = "LV33",
        [1] = { ['x'] = 267.58, ['y'] = -2029.38, ['z'] = 18.82, ['h'] = 142.23 }
    },	
    [461] = { ['x'] = 240.68, ['y'] = -2021.42, ['z'] = 18.71, ['name'] = "LV34", 
        [1] = { ['x'] = 246.74, ['y'] = -2035.94, ['z'] = 18.53, ['h'] = 228.90 }
    },	
    [462] = { ['x'] = 241.9, ['y'] = -2042.78, ['z'] = 18.02, ['name'] = "LV35",
        [1] = { ['x'] = 245.74, ['y'] = -2053.88, ['z'] = 18.1,  ['h'] = 134.18 }
    },
    [463] = { ['x'] = -442.95, ['y'] = 6202.62, ['z'] = 29.56, ['name'] = "PB01",
        [1] = { ['x'] = -435.4, ['y'] = 6206.42, ['z'] = 29.57, ['h'] = 278.13 }
    },
    [464] = { ['x'] = -375.5, ['y'] = 6187.37, ['z'] = 31.54, ['name'] = "PB02",
        [1] = { ['x'] = -379.5, ['y'] = 6184.85, ['z'] = 31.4, ['h'] = 223.82 }
    },
    [465] = { ['x'] = -361.91, ['y'] = 6204.76, ['z'] = 31.58, ['name'] = "PB03",
        [1] = { ['x'] = -367.92, ['y'] = 6200.05, ['z'] = 31.4, ['h'] = 224.98 }
    },
    [466] = { ['x'] = -359.1, ['y'] = 6227.29, ['z'] = 31.5, ['name'] = "PB04",
        [1] = { ['x'] = -349.5, ['y'] = 6217.17, ['z'] = 31.4, ['h'] = 223.88 }
    },
    [467] = { ['x'] = -381.48, ['y'] = 6254.9, ['z'] = 31.49, ['name'] = "PB05",
        [1] = { ['x'] = -388.73, ['y'] = 6273.42, ['z'] = 30.02, ['h'] = 50.83 }
    },
    [468] = { ['x'] = -360.84, ['y'] = 6265.04, ['z'] = 31.53, ['name'] = "PB06",
        [1] = { ['x'] = -352.17, ['y'] = 6265.07, ['z'] = 31.32, ['h'] = 46.14 }
    },
    [469] = { ['x'] = -436.46, ['y'] = 6264.1, ['z'] = 30.09, ['name'] = "PB07",
        [1] = { ['x'] = -429.99, ['y'] = 6260.87, ['z'] = 30.31, ['h'] = 258.67 }
    },
    [470] = { ['x'] = -402.95, ['y'] = 6317.15, ['z'] = 28.95, ['name'] = "PB08",
        [1] = { ['x'] = -396.68, ['y'] = 6311.99, ['z'] = 28.84, ['h'] = 220.70 }
    },
    [471] = { ['x'] = -364.3, ['y'] = 6337.74, ['z'] = 29.85, ['name'] = "PB09",
        [1] = { ['x'] = -360.16, ['y'] = 6328.54, ['z'] = 29.75, ['h'] = 220.61 }
    },
    [472] = { ['x'] = -311.14, ['y'] = 6310.94, ['z'] = 32.48, ['name'] = "PB10",
        [1] = { ['x'] = -318.17, ['y'] = 6317.76, ['z'] = 31.77, ['h'] = 45.39 }
    },
    [473] = { ['x'] = -291.83, ['y'] = 6335.9, ['z'] = 32.49, ['name'] = "PB11",
        [1] = { ['x'] = -296.49, ['y'] = 6340.57, ['z'] = 31.82, ['h'] = 46.26 }
    },
    [474] = { ['x'] = -272.11, ['y'] = 6353.73, ['z'] = 32.49, ['name'] = "PB12",
        [1] = { ['x'] = -267.41, ['y'] = 6355.22, ['z'] = 32.4, ['h'] = 47.15 }
    },
    [475] = { ['x'] = -250.27, ['y'] = 6355.12, ['z'] = 31.5, ['name'] = "PB13",
        [1] = { ['x'] = -255.08, ['y'] = 6360.48, ['z'] = 31.39, ['h'] = 45.08 }
    },
    [476] = { ['x'] = -271.22, ['y'] = 6408.91, ['z'] = 31.12, ['name'] = "PB14",
        [1] = { ['x'] = -265.26, ['y'] = 6406.49, ['z'] = 30.88, ['h'] = 210.49 }
    }, 
    [477] = { ['x'] = -217.34, ['y'] = 6374.6, ['z'] = 31.68, ['name'] = "PB15",
        [1] = { ['x'] = -219.54, ['y'] = 6383.16, ['z'] = 31.52, ['h'] = 45.87 }
    },
    [478] = { ['x'] = -238.3, ['y'] = 6423.56, ['z'] = 31.46, ['name'] = "PB16",
        [1] = { ['x'] = -233.04, ['y'] = 6420.27, ['z'] = 31.16, ['h'] = 220.84 }
    },
    [479] = { ['x'] = -201.42, ['y'] = 6396.75, ['z'] = 31.87, ['name'] = "PB17",
        [1] = { ['x'] = -201.53, ['y'] = 6401.82, ['z'] = 31.77, ['h'] = 46.62 }
    },
    [480] = { ['x'] = -229.57, ['y'] = 6445.5, ['z'] = 31.2, ['name'] = "PB18",
        [1] = { ['x'] = -224.33, ['y'] = 6435.29, ['z'] = 31.11, ['h'] = 229.64 }
    },
    [481] = { ['x'] = -187.33, ['y'] = 6412.01, ['z'] = 31.92, ['name'] = "PB19",
        [1] = { ['x'] = -187.43, ['y'] = 6418.12, ['z'] = 31.78, ['h'] = 44.99 }
    },
    [482] = { ['x'] = -122.88, ['y'] = 6561.7, ['z'] = 29.53, ['name'] = "PB20",
        [1] = { ['x'] = -115.59, ['y'] = 6567.64, ['z'] = 29.43, ['h'] = 224.24 }
    },
    [483] = { ['x'] = -101.69, ['y'] = 6531.68, ['z'] = 29.81, ['name'] = "PB21",
        [1] = { ['x'] = -106.48, ['y'] = 6536.09, ['z'] = 29.72, ['h'] = 45.20 }
    },
    [484] = { ['x'] = -37.32, ['y'] = 6578.82, ['z'] = 32.35, ['name'] = "PB22",
        [1] = { ['x'] = -40.97, ['y'] = 6593.44, ['z'] = 30.34, ['h'] = 37.22 }
    },
    [485] = { ['x'] = -15.06, ['y'] = 6566.75, ['z'] = 31.91, ['name'] = "PB23",
        [1] = { ['x'] = -8.44, ['y'] = 6561.16, ['z'] = 31.88, ['h'] = 224.22 }
    },
    [486] = { ['x'] = 11.48, ['y'] = 6578.36, ['z'] = 33.08, ['name'] = "PB24",
        [1] = { ['x'] = 15.78, ['y'] = 6583.02, ['z'] = 32.35, ['h'] = 223.198 }
    },
    [487] = { ['x'] = -17.04, ['y'] = 6598.51, ['z'] = 31.48, ['name'] = "PB25",
        [1] = { ['x'] = -8.5, ['y'] = 6598.24, ['z'] = 31.38, ['h'] = 39.88 }
    },
    [488] = { ['x'] = -43.93, ['y'] = 6634.26, ['z'] = 30.23, ['name'] = "PB26",
        [1] = { ['x'] = -52.4, ['y'] = 6623.94, ['z'] = 29.87, ['h'] = 221,59 }
    },
    [489] = { ['x'] = -14.79, ['y'] = 6650.52, ['z'] = 31.15, ['name'] = "PB27",
        [1] = { ['x'] = -15.82, ['y'] = 6645.42, ['z'] = 31.03, ['h'] = 208.00 }
    },
    [490] = { ['x'] = 2.37, ['y'] = 6618.26, ['z'] = 31.47, ['name'] = "PB28",
        [1] = { ['x'] = -5.0, ['y'] = 6618.68, ['z'] = 31.34, ['h'] = 60.09 }
    },
    [491] = { ['x'] = 25.06, ['y'] = 6601.97, ['z'] = 32.48, ['name'] = "PB29",
        [1] = { ['x'] = 36.23, ['y'] = 6606.74, ['z'] = 32.38, ['h'] = 267.62 }
    },
    [492] = { ['x'] = 24.79, ['y'] = 6659.22, ['z'] = 31.65, ['name'] = "PB30",
        [1] = { ['x'] = 21.16, ['y'] = 6661.48, ['z'] = 31.44, ['h'] = 182.65 }
    },
    [493] = { ['x'] = 81.27, ['y'] = 6644.04, ['z'] = 31.93, ['name'] = "PB31",
        [1] = { ['x'] = 81.27, ['y'] = 6644.04, ['z'] = 31.93, ['h'] = 142.72 }
    },
	[494] = { ['x'] = 1245.08, ['y'] = -518.7, ['z'] = 69.0, ['name'] = "LS11",
		[1] = { ['x'] = 1247.17, ['y'] = -522.7, ['z'] = 69.25, ['h'] = 257.36 }
	},
	[495] = { ['x'] = 1251.25, ['y'] = -490.29, ['z'] = 69.5, ['name'] = "LS12",
		[1] = { ['x'] = 1260.63, ['y'] = -494.22, ['z'] = 69.59, ['h'] = 255.66 }
	},
	[496] = { ['x'] = 1259.55, ['y'] = -477.81, ['z'] = 70.19, ['name'] = "LS13",
		[1] = { ['x'] = 1280.06, ['y'] = -472.81, ['z'] = 69.24, ['h'] = 170.02 }
	},
	[497] = { ['x'] = 1268.56, ['y'] = -461.81, ['z'] = 69.84, ['name'] = "LS14",
		[1] = { ['x'] = 1270.98, ['y'] = -463.9, ['z'] = 69.87, ['h'] = 328.18 }
	},
	[498] = { ['x'] = 1261.12, ['y'] = -426.7, ['z'] = 69.81, ['name'] = "LS15",
		[1] = { ['x'] = 1261.45, ['y'] = -419.35, ['z'] = 69.58, ['h'] = 297.04 }
	},
	[499] = { ['x'] = 1234.75, ['y'] = -578.25, ['z'] = 69.49, ['name'] = "LS16",
		[1] = { ['x'] = 1243.86, ['y'] = -579.36, ['z'] = 69.64, ['h'] = 271.53 }
	},
	[501] = { ['x'] = 1236.79, ['y'] = -589.55, ['z'] = 69.79, ['name'] = "LS17",
		[1] = { ['x'] = 1242.92, ['y'] = -586.85, ['z'] = 69.55, ['h'] = 269.57 }
	},
	[502] = { ['x'] = 1250.47, ['y'] = -626.17, ['z'] = 69.35, ['name'] = "LS18",
		[1] = { ['x'] = 1259.06, ['y'] = -624.91, ['z'] = 69.58, ['h'] = 296.96 }
	},
	[503] = { ['x'] = 1257.67, ['y'] = -660.38, ['z'] = 67.93, ['name'] = "LS19",
		[1] = { ['x'] = 1271.84, ['y'] = -659.12, ['z'] = 68.00, ['h'] = 293.69 }
	},
	[504] = { ['x'] = 1267.25, ['y'] = -673.65, ['z'] = 65.75, ['name'] = "LS20",
		[1] = { ['x'] = 1276.75, ['y'] = -673.42, ['z'] = 66.25, ['h'] = 277.48 }
	},
	[505] = { ['x'] = 1259.79, ['y'] = -711.08, ['z'] = 64.72, ['name'] = "LS21",
		[1] = { ['x'] = 1263.72, ['y'] = -716.66, ['z'] = 64.75, ['h'] = 239.07 }
	},
	[506] = { ['x'] = 1225.19, ['y'] = -723.04, ['z'] = 60.64, ['name'] = "LS22",
		[1] = { ['x'] = 1223.46, ['y'] = -730.21, ['z'] = 60.40, ['h'] = 163.48 }
	},
	[507] = { ['x'] = 1228.5, ['y'] = -703.47, ['z'] = 60.68, ['name'] = "LS23",
		[1] = { ['x'] = 1217.85, ['y'] = -704.09, ['z'] = 60.70, ['h'] = 97.24 }
	},
	[508] = { ['x'] = 1220.91, ['y'] = -664.18, ['z'] = 63.13, ['name'] = "LS24",
		[1] = { ['x'] = 1214.36, ['y'] = -665.12, ['z'] = 62.85, ['h'] = 103.07 }
	},
	[509] = { ['x'] = 1206.75, ['y'] = -614.0, ['z'] = 66.12, ['name'] = "LS25",
		[1] = { ['x'] = 1199.98, ['y'] = -612.47, ['z'] = 65.36, ['h'] = 94.40 }
	},
	[510] = { ['x'] = 1192.48, ['y'] = -597.08, ['z'] = 64.01, ['name'] = "LS26",
		[1] = { ['x'] = 1188.28, ['y'] = -595.06, ['z'] = 64.23, ['h'] = 34.45 }
	},
	[511] = { ['x'] = 1189.79, ['y'] = -573.78, ['z'] = 64.32, ['name'] = "LS27",
		[1] = { ['x'] = 1185.82, ['y'] = -569.96, ['z'] = 64.56, ['h'] = 25.68 }
	},
	[512] = { ['x'] = 1191.61, ['y'] = -554.97, ['z'] = 64.71, ['name'] = "LS28",
		[1] = { ['x'] = 1187.47, ['y'] = -550.38, ['z'] = 64.83, ['h'] = 86.85 }
	},
	[513] = { ['x'] = 1089.59, ['y'] = -495.42, ['z'] = 65.07, ['name'] = "LS29",
		[1] = { ['x'] = 1084.78, ['y'] = -493.34, ['z'] = 64.40, ['h'] = 79.01 }
	},
	[514] = { ['x'] = 1101.7, ['y'] = -468.42, ['z'] = 67.06, ['name'] = "LS30",
		[1] = { ['x'] = 1091.28, ['y'] = -470.87, ['z'] = 65.47, ['h'] = 77.7 }
	},
	[515] = { ['x'] = 1111.03, ['y'] = -417.0, ['z'] = 67.16, ['name'] = "LS31",
		[1] = { ['x'] = 1111.15, ['y'] = -419.57, ['z'] = 67.43, ['h'] = 83.31 }
	},
	[516] = { ['x'] = 1112.77, ['y'] = -394.29, ['z'] = 68.74, ['name'] = "LS32",
		[1] = { ['x'] = 1106.07, ['y'] = -399.24, ['z'] = 68.20, ['h'] = 78.01 }
	},
	[517] = { ['x'] = 1057.42, ['y'] = -384.09, ['z'] = 67.86, ['name'] = "LS33",
		[1] = { ['x'] = 1056.9, ['y'] = -388.45, ['z'] = 68.09, ['h'] = 221.13 }
	},
	[518] = { ['x'] = 1021.13, ['y'] = -414.33, ['z'] = 65.95, ['name'] = "LS34",
		[1] = { ['x'] = 1022.37, ['y'] = -419.52, ['z'] = 66.05, ['h'] = 219.15 }
	},
	[519] = { ['x'] = 1009.82, ['y'] = -418.88, ['z'] = 64.96, ['name'] = "LS35",
		[1] = { ['x'] = 1015.92, ['y'] = -423.87, ['z'] = 65.32, ['h'] = 217.10 }
	},
	[520] = { ['x'] = 987.71, ['y'] = -438.07, ['z'] = 63.75, ['name'] = "LS36",
		[1] = { ['x'] = 995.76, ['y'] = -435.43, ['z'] = 64.23, ['h'] = 271.01 }
	},
	[521] = { ['x'] = 971.53, ['y'] = -447.94, ['z'] = 62.41, ['name'] = "LS37",
		[1] = { ['x'] = 975.54, ['y'] = -454.41, ['z'] = 62.86, ['h'] = 213.74 }
	},
	[522] = { ['x'] = 939.3, ['y'] = -463.22, ['z'] = 61.26, ['name'] = "LS38",
		[1] = { ['x'] = 942.05, ['y'] = -469.79, ['z'] = 61.53, ['h'] = 212.33 }
	},
	[523] = { ['x'] = 928.77, ['y'] = -475.65, ['z'] = 60.70, ['name'] = "LS39",
		[1] = { ['x'] = 933.31, ['y'] = -480.49, ['z'] = 60.88, ['h'] =  203.27 }
	},
	[524] = { ['x'] = 909.42, ['y'] = -489.73, ['z'] = 59.02, ['name'] = "LS40",
		[1] = { ['x'] = 914.46, ['y'] = -490.17, ['z'] = 59.29, ['h'] = 204.27 }
	},
	[525] = { ['x'] = 873.98, ['y'] = -503.77, ['z'] = 57.50, ['name'] = "LS41",
		[1] = { ['x'] = 874.77, ['y'] = -507.45, ['z'] = 57.72, ['h'] = 226.29 }
	},
	[526] = { ['x'] = 854.95, ['y'] = -516.17, ['z'] = 57.33, ['name'] = "LS42",
		[1] = { ['x'] = 858.81, ['y'] = -522.39, ['z'] = 57.59, ['h'] = 227.66 }
	},
	[527] = { ['x'] = 848.57, ['y'] = -540.12, ['z'] = 57.33, ['name'] = "LS43",
		[1] = { ['x'] = 853.51, ['y'] = -542.76, ['z'] = 57.60, ['h'] = 266.06 }
	},
	[528] = { ['x'] = 842.1, ['y'] = -567.41, ['z'] = 57.71, ['name'] = "LS44",
		[1] = { ['x'] = 849.29, ['y'] = -567.47, ['z'] = 57.99, ['h'] = 279.71 },
	},
    -- MODELO COM INTERIOR , SE QUISER ADICIONAR INTERIOR NAS OUTRAS BASTA SEGUIR O MODELO
	[529] = { ['name'] = "LS45", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 868.47, -594.02, 58.30,114.71 }, -- blip entrada a pé
            ["veiculo"] = { 872.86, -590.11, 58.28,114.71 } -- blip entrada e saida com carro
        },
        ["interior"] = "pequena" -- interior
    },
	[530] = { ['name'] = "LS46", ['payment'] = false, ['perm'] = false,
        ["entrada"] = {
            ["blip"] = { 875.58, -602.34, 58.45,114.71 },
            ["veiculo"] = { 875.55, -598.36, 58.45,316.61 }
        },
        ["interior"] = "pequena"
    },

	[531] = { ['x'] = 912.15, ['y'] = -631.81, ['z'] = 58.05, ['name'] = "LS47",
		[1] = { ['x'] = 917.67, ['y'] = -627.46, ['z'] = 58.32, ['h'] = 319.36 }
	},
	[532] = { ['x'] = 913.03, ['y'] = -645.12, ['z'] = 57.87, ['name'] = "LS48",
		[1] = { ['x'] = 917.96, ['y'] = -639.77, ['z'] = 58.14, ['h'] = 318.18 }
	},
	[533] = { ['x'] = 946.14, ['y'] = -657.5, ['z'] = 58.02, ['name'] = "LS49",
		[1] = { ['x'] = 951.67, ['y'] = -654.13, ['z'] = 58.16, ['h'] = 309.34 }
	},
	[534] = { ['x'] = 940.18, ['y'] = -672.19, ['z'] = 58.02, ['name'] = "LS50",
		[1] = { ['x'] = 946.99, ['y'] = -669.22, ['z'] = 58.29, ['h'] = 297.96 }
	},
	[535] = { ['x'] = 969.7, ['y'] = -688.32, ['z'] = 57.95, ['name'] = "LS51",
		[1] = { ['x'] = 973.59, ['y'] = -685.58, ['z'] = 57.91, ['h'] = 309.99 }
	},
	[536] = { ['x'] = 976.24, ['y'] = -713.97, ['z'] = 57.87, ['name'] = "LS52",
		[1] = { ['x'] = 982.5, ['y'] = -709.42, ['z'] = 57.88, ['h'] = 312.02 }
	},
	[537] = { ['x'] = 1004.32, ['y'] = -734.1, ['z'] = 57.46, ['name'] = "LS53",
		[1] = { ['x'] = 1008.02, ['y'] = -731.13, ['z'] = 57.88, ['h'] = 311.05 }
	},
	[538] = { ['x'] = 981.21, ['y'] = -614.8, ['z'] = 58.84, ['name'] = "LS54",
		[1] = { ['x'] = 973.52, ['y'] = -619.61, ['z'] = 59.10, ['h'] = 128.10 }
	},
	[539] = { ['x'] = 959.79, ['y'] = -601.7, ['z'] = 59.50, ['name'] = "LS55",
		[1] = { ['x'] = 955.45, ['y'] = -598.08, ['z'] = 59.65, ['h'] = 27.96 }
	},
	[540] = { ['x'] = 984.25, ['y'] = -579.14, ['z'] = 59.28, ['name'] = "LS56",
		[1] = { ['x'] = 982.93, ['y'] = -572.6, ['z'] = 59.53, ['h'] = 31.32 }
	},
	[541] = { ['x'] = 1008.54, ['y'] = -565.15, ['z'] = 60.20, ['name'] = "LS57",
		[1] = { ['x'] = 1012.51, ['y'] = -563.56, ['z'] = 60.44, ['h'] = 263.72 }
	},
	[542] = { ['x'] = 943.81, ['y'] = -243.89, ['z'] = 68.63, ['name'] = "LS58",
		[1] = { ['x'] = 939.22, ['y'] = -250.12, ['z'] = 68.69, ['h'] = 150.37 }
	},
	[543] = { ['x'] = 1003.79, ['y'] = -588.12, ['z'] = 59.14, ['name'] = "LS59",
		[1] = { ['x'] = 1009.07, ['y'] = -590.25, ['z'] = 59.20, ['h'] = 258.95 }
	},
	[544] = { ['x'] = 922.71, ['y'] = -564.06, ['z'] = 57.97, ['name'] = "LS60",
		[1] = { ['x'] = 926.46, ['y'] = -567.39, ['z'] = 58.24, ['h'] = 206.14 }
	},
	[545] = { ['x'] = 956.87, ['y'] = -546.73, ['z'] = 59.53, ['name'] = "LS61",
		[1] = { ['x'] = 957.91, ['y'] = -552.49, ['z'] = 59.55, ['h'] = 211.12 }
	},
	[546] = { ['x'] = 981.96, ['y'] = -530.0, ['z'] = 60.12, ['name'] = "LS62",
		[1] = { ['x'] = 983.27, ['y'] = -536.41, ['z'] = 60.19, ['h'] = 211.11 }
	},
	[547] = { ['x'] = 1001.36, ['y'] = -510.47, ['z'] = 60.70, ['name'] = "LS63",
		[1] = { ['x'] = 1003.89, ['y'] = -518.48, ['z'] = 60.98, ['h'] = 205.24 }
	},
	[548] = { ['x'] = 1049.28, ['y'] = -493.71, ['z'] = 63.91, ['name'] = "LS64",
		[1] = { ['x'] = 1049.91, ['y'] = -488.79, ['z'] = 64.19, ['h'] = 257.03 }
	},
	[549] = { ['x'] = 1049.12, ['y'] = -479.89, ['z'] = 64.10, ['name'] = "LS65",
		[1] = { ['x'] = 1056.64, ['y'] = -483.32, ['z'] = 64.11, ['h'] = 257.85 }
	},
	[550] = { ['x'] = 1055.36, ['y'] = -445.56, ['z'] = 65.97, ['name'] = "LS66",
		[1] = { ['x'] = 1062.56, ['y'] = -445.67, ['z'] = 66.16, ['h'] = 257.58 }
	},
	[551] = { ['x'] = 1020.06, ['y'] = -464.4, ['z'] = 63.90, ['name'] = "LS67",
		[1] = { ['x'] = 1019.04, ['y'] = -459.29, ['z'] = 64.37, ['h'] = 38.05 }
	},
	[552] = { ['x'] = 966.19, ['y'] = -505.37, ['z'] = 61.74, ['name'] = "LS68",
		[1] = { ['x'] = 960.86, ['y'] = -500.52, ['z'] = 61.65, ['h'] = 29.80 }
	},
	[553] = { ['x'] = 950.42, ['y'] = -516.97, ['z'] = 60.25, ['name'] = "LS69",
		[1] = { ['x'] = 948.5, ['y'] = -511.66, ['z'] = 60.50, ['h'] = 29.22 }
	},
	[554] = { ['x'] = 921.11, ['y'] = -527.47, ['z'] = 59.58, ['name'] = "LS70",
		[1] = { ['x'] = 915.83, ['y'] = -522.63, ['z'] = 59.03, ['h'] = 25.35 }
	},
	[555] = { ['x'] = 893.88, ['y'] = -547.44, ['z'] = 58.17, ['name'] = "LS71",
		[1] = { ['x'] = 888.36, ['y'] = -551.92, ['z'] = 58.24, ['h'] = 115.00 }
	},
	[556] = { ['x'] = 1103.28, ['y'] = -429.62, ['z'] = 67.4, ['name'] = "LS72",
		[1] = { ['x'] = 1097.86, ['y'] = -428.24, ['z'] = 66.68, ['h'] = 80.97 }
	},
    [557] = { ['x'] = -1127.91, ['y'] = -1071.4, ['z'] = 1.44, ['name'] = "VZ01",
		[1] = { ['x'] = -1127.91, ['y'] = -1071.4, ['z'] = 1.44, ['h'] = 349.49 }
	},
    [558] = { ['x'] = -1112.11, ['y'] = -1061.77, ['z'] = 1.45, ['name'] = "VZ02", 
		[1] = { ['x'] = -1112.11, ['y'] = -1061.77, ['z'] = 1.45, ['h'] = 349.49 }
	},
    [559] = { ['x'] = -1112.11, ['y'] = -1061.77, ['z'] = 1.45, ['name'] = "VZ03",
		[1] = { ['x'] = -1112.11, ['y'] = -1061.77, ['z'] = 1.45, ['h'] = 349.49 }
	},
    [560] = { ['x'] = -1075.31, ['y'] = -1047.67, ['z'] = 1.48, ['name'] = "VZ04",
		[1] = { ['x'] = -1075.31, ['y'] = -1047.67, ['z'] = 1.48, ['h'] = 30.89 }
	},
    [561] = { ['x'] = -1079.19, ['y'] = -1049.76, ['z'] = 1.48, ['name'] = "VZ05",
		[1] = { ['x'] = -1079.19, ['y'] = -1049.76, ['z'] = 1.48, ['h'] = 30.89 }
	},
    [562] = { ['x'] = -1082.86, ['y'] = -1052.02, ['z'] = 1.48, ['name'] = "VZ06",
		[1] = { ['x'] = -1082.86, ['y'] = -1052.02, ['z'] = 1.48, ['h'] = 30.89 }
	},
    [563] = { ['x'] = -1075.79, ['y'] = -1035.97, ['z'] = 1.48, ['name'] = "VZ07",
		[1] = { ['x'] = -1075.79, ['y'] = -1035.97, ['z'] = 1.48, ['h'] = 349.49 }
	},
    [564] = { ['x'] = -1086.42, ['y'] = -1039.45, ['z'] = 1.47, ['name'] = "VZ08",
		[1] = { ['x'] = -1086.42, ['y'] = -1039.45, ['z'] = 1.47, ['h'] = 208.49 }
	},
    [565] = { ['x'] = -1095.15, ['y'] = -1044.84, ['z'] = 1.51, ['name'] = "VZ09",
		[1] = { ['x'] = -1095.15, ['y'] = -1044.84, ['z'] = 1.51, ['h'] = 208.49 }
	},
    [566] = { ['x'] = -1107.47, ['y'] = -1049.54, ['z'] = 1.48, ['name'] = "VZ10",
		[1] = { ['x'] = -1107.47, ['y'] = -1049.54, ['z'] = 1.48, ['h'] = 208.49 }
	},
    [567] = { ['x'] = -1117.15, ['y'] = -1058.43, ['z'] = 1.47, ['name'] = "VZ11",
		[1] = { ['x'] = -1117.15, ['y'] = -1058.43, ['z'] = 1.47, ['h'] = 349.49 }
	},
    [568] = { ['x'] = -1134.89, ['y'] = -1061.38, ['z'] = 1.48, ['name'] = "VZ12",
		[1] = { ['x'] = -1134.89, ['y'] = -1061.38, ['z'] = 1.48, ['h'] = 208.49 }
	},
    [569] = { ['x'] = -1073.37, ['y'] = -1157.52, ['z'] = 1.48, ['name'] = "VZ13",
		[1] = { ['x'] = -1073.37, ['y'] = -1157.52, ['z'] = 1.48, ['h'] = 303.59 }
	},
    [570] = { ['x'] = -1064.83, ['y'] = -1144.72, ['z'] = 1.49, ['name'] = "VZ14",
		[1] = { ['x'] = -1064.83, ['y'] = -1144.72, ['z'] = 1.49, ['h'] = 210.49 }
	},
    [571] = { ['x'] = -1043.21, ['y'] = -1139.76, ['z'] = 1.47, ['name'] = "VZ15",
		[1] = { ['x'] = -1043.21, ['y'] = -1139.76, ['z'] = 1.47, ['h'] = 303.59 }
	},
    [572] = { ['x'] = -1062.05, ['y'] = 438.05, ['z'] = 73.87, ['name'] = "FH17",
		[1] = { ['x'] = -1064.37, ['y'] = 437.54, ['z'] = 73.87, ["h"] = 101.00 }
	},
    [573] = { ['x'] = -514.3, ['y'] = 427.64, ['z'] = 97.21, ['name'] = "FH46",
		[1] = { ['x'] = -514.3, ['y'] = 427.64, ['z'] = 97.21, ["h"] = 90.48 }
	},
    [574] = { ['x'] = -1050.5, ['y'] = 220.95, ['z'] = 63.77, ['name'] = "LX07",
		[1] = { ['x'] = -1045.11, ['y'] = 217.9, ['z'] = 63.42, ["h"] = 158.57 }
	},
    [575] = { ['x'] = -380.18, ['y'] = 521.75, ['z'] = 120.81, ['name'] = "FH57",
		[1] = { ['x'] = -380.18, ['y'] = 521.75, ['z'] = 120.81, ["h"] = 158.57 }
	},
    [577] = { ['x'] = -1959.76, ['y'] = -507.99, ['z'] = 11.87, ['name'] = "PR02",
        [1] = { ['x'] = -1959.76, ['y'] = -507.99, ['z'] = 11.87, ["h"] = 143.16 }
	},
    [580] = { ['x'] = -1940.84, ['y'] = -531.84, ['z'] = 11.85, ['name'] = "PR05",
		[1] = { ['x'] = -1938.42, ['y'] = -528.71, ['z'] = 11.25, ["h"] = 320.00 }
    },

    --##########################[NPC]####################################--

    [581] = { ["name"] = "Motorista", ["payment"] = false, ["perm"] = false,
        ["blip"] = { 455.18, -594.35, 28.51 }, -- cordenada do blip da garagem
        ["drawM"] = 39, -- numero do DrawMaker ! pegue aqui -> https://docs.fivem.net/docs/game-references/markers/
        ["npc"] = 'a_m_o_soucent_01', -- nome do npc ! pegue aqui -> https://docs.fivem.net/docs/game-references/ped-models/
        ["spawnar"] = { 444.89, -575.66, 28.5, 215.25 }, -- como tem npc acima coloque aqui a cordenada que o onibus aparece longe do blip final
        ["pointSpawn"] = { 463.5, -599.85, 28.5, 172.87 }, -- aqui a cordenada final que o npc leva até o player o veiculo! 
    },
    
   --##########################[INTERIOR]####################################--
	[582] = { ["name"] = "policia", ["payment"] = false, ["perm"] = "policia.permissao",
        ["blip"] = { 409.24, -1623.3, 29.3 },            -- blip da garagem
        ["drawM"] = 36, -- numero do DrawMaker ! pegue aqui -> https://docs.fivem.net/docs/game-references/markers/
        ["entrada"] = {
            ["blip"] = { 402.86, -1632.13, 29.3, 232.99 }, 
            ["veiculo"] = { 402.86, -1632.13, 29.3, 232.99 }     -- blip da garagem se estiver no carro
        },
        ["interior"] = "gigante"   -- se quiser espesificar o interior
    },
    --#########################[SPAWN SOMENTE]################################--

    [583] = { ["name"] = "Bicicletas", ["payment"] = false, ["perm"] = false,
        ["blip"] = { -1031.17, -2728.17, 13.76 }, -- cordenada do blip da garagem
        ["drawM"] = 38, -- numero do DrawMaker ! pegue aqui -> https://docs.fivem.net/docs/game-references/markers/
        ["npc"] = nil, -- se não quer npc na garagem deixe nil 
        ["spawnar"] = { -1029.67, -2724.99, 13.7,56.25 }, -- como essa garagem é só para spawnar o veiculo , coloque aqui e abaixo a mesma cordenada final proximo ao player
        ["pointSpawn"] = { -1029.67, -2724.99, 13.7,56.25 }, 
    },
    -- [584] = { ["name"] = "lixeiro", ["payment"] = false, ["perm"] = false,
    --     ["blip"] = { -347.37, -1574.87, 25.24 }, -- cordenada do blip da garagem
    --     ["drawM"] = 39, -- numero do DrawMaker ! pegue aqui -> https://docs.fivem.net/docs/game-references/markers/
    --     ["npc"] = nil, -- se não quer npc na garagem deixe nil 
    --     ["spawnar"] = { -340.8, -1561.18, 25.24, 88.55 }, -- como essa garagem é só para spawnar o veiculo , coloque aqui e abaixo a mesma cordenada final proximo ao player
    --     ["pointSpawn"] = { -340.8, -1561.18, 25.24, 88.55 }, 
    -- },
    -- [585] = { ["name"] = "entregador", ["payment"] = false, ["perm"] = false,
    --     ["blip"] = { -516.09, -679.37, 33.68 }, -- cordenada do blip da garagem
    --     ["drawM"] = 38, -- numero do DrawMaker ! pegue aqui -> https://docs.fivem.net/docs/game-references/markers/
    --     ["npc"] = nil, -- se não quer npc na garagem deixe nil 
    --     ["spawnar"] = { -512.86, -679.17, 33.19, 347.72 }, -- como essa garagem é só para spawnar o veiculo , coloque aqui e abaixo a mesma cordenada final proximo ao player
    --     ["pointSpawn"] = { -512.86, -679.17, 33.19, 347.72 }, 
    -- },
    -- [586] = { ["name"] = "transporte", ["payment"] = false, ["perm"] = false,
    --     ["blip"] = { -1.0, -712.99, 32.34 }, -- cordenada do blip da garagem
    --     ["drawM"] = 39, -- numero do DrawMaker ! pegue aqui -> https://docs.fivem.net/docs/game-references/markers/
    --     ["npc"] = nil, -- se não quer npc na garagem deixe nil 
    --     ["spawnar"] = { -3.65, -710.27, 32.34, 346.05 }, -- como essa garagem é só para spawnar o veiculo , coloque aqui e abaixo a mesma cordenada final proximo ao player
    --     ["pointSpawn"] = { -3.65, -710.27, 32.34, 346.05 }, 
    -- },
    -- [587] = { ["name"] = "carteiro", ["payment"] = false, ["perm"] = false,
    --     ["blip"] = { 128.99, 97.49, 83.51 }, -- cordenada do blip da garagem
    --     ["drawM"] = 39, -- numero do DrawMaker ! pegue aqui -> https://docs.fivem.net/docs/game-references/markers/
    --     ["npc"] = nil, -- se não quer npc na garagem deixe nil 
    --     ["spawnar"] = { 117.29, 99.13, 80.96, 174.79 }, -- como essa garagem é só para spawnar o veiculo , coloque aqui e abaixo a mesma cordenada final proximo ao player
    --     ["pointSpawn"] = { 117.29, 99.13, 80.96, 174.79 }, 
    -- },
    -- [588] = { ["name"] = "caminhoneiro", ["payment"] = false, ["perm"] = false,
    --     ["blip"] = { 1239.7, -3174.29, 7.11 }, -- cordenada do blip da garagem
    --     ["drawM"] = 39, -- numero do DrawMaker ! pegue aqui -> https://docs.fivem.net/docs/game-references/markers/
    --     ["npc"] = nil, -- se não quer npc na garagem deixe nil 
    --     ["spawnar"] = { 1248.34, -3166.85, 5.78, 267.91 }, -- como essa garagem é só para spawnar o veiculo , coloque aqui e abaixo a mesma cordenada final proximo ao player
    --     ["pointSpawn"] = { 1248.34, -3166.85, 5.78, 267.91 }, 
    -- },
	[589] = { ["name"] = "hospital", ["payment"] = false, ["perm"] = "paramedico.permissao",
        ["blip"] = { 1132.66, -1596.99, 34.74 },            -- blip da garagem
        ["drawM"] = 36, -- numero do DrawMaker ! pegue aqui -> https://docs.fivem.net/docs/game-references/markers/
        ["entrada"] = {
            ["blip"] = { 1135.86, -1599.98, 34.7, 189.16 }, 
            ["veiculo"] = { 1135.86, -1599.98, 34.7, 189.16 }     -- blip da garagem se estiver no carro
        },
        ["interior"] = "grande"   -- se quiser espesificar o interior
    },
    [590] = { ["name"] = "mecanica", ["payment"] = false, ["perm"] = "mecanico.permissao",
        ["blip"] = { 823.73, -2090.43, 29.69 },  -- cordenada do blip da garagem
        ["drawM"] = 39, -- numero do DrawMaker ! pegue aqui -> https://docs.fivem.net/docs/game-references/markers/
        ["npc"] = nil, -- se não quer npc na garagem deixe nil 
        ["spawnar"] = { 824.62, -2085.88, 29.69, 355.93 }, -- como essa garagem é só para spawnar o veiculo , coloque aqui e abaixo a mesma cordenada final proximo ao player
        ["pointSpawn"] = { 824.62, -2085.88, 29.69, 355.93 }, 
    },

} 

--###############################################################
-- CONFIGURE ABAIXO CARROS NA GARAGEM DE SERVIÇO ################
--###############################################################

Config.workgarage = {
    ["Bicicletas"] = {
        "bmx"
    },
    ["Motorista"] = {
        "bus",
    },
    ['lixeiro'] = {
        "trash",
    },
    ['entregador'] = {
        "faggio2",
    },
    ['transporte'] = {
        "stockade",
    },
    ['carteiro'] = {
        "boxville2",
    },
    ['caminhoneiro'] = {
        "phantom",
    },
 
    ["policia"] = {
         'VRa3',
         'VRa4',
         'VRdm1200',
         'VRq8',
         'VRraptor',
         'VRrs5',
         'VRrs6',
         'VRrs6av',
    },
 
    ["hospital"] = {
        'ambulance',
    },
 
    ["mecanica"] = {
         'flatbed3',
         'yosemite',
     },
    
}

--###############################################################
-- BLACK LIST DE CARRO EM INTERIOR ##############################
--###############################################################

Config.blacklistCar = {  -- pode colocar carros para não aparecerem em certor interiores conforme a config                          
    ["grande"] = {
        "pounder",
        "mule",
        "mule2",
        "mule3",
        "swift2",
        "volatus",
        "luxor2",
    },
    ["media"] = {
        "pounder",
        "mule",
        "mule2",
        "mule3",
        "swift2",
        "volatus",
        "luxor2",
    },
    ["pequena"] = {
        "pounder",
        "mule",
        "mule2",
        "mule3",
        "swift2",
        "volatus",
        "luxor2",
    },
    ["extra_grande"] = {
        "pounder",
        "mule",
        "mule2",
        "mule3",
        "swift2",
        "volatus",
        "luxor2",
    },
    ["garage_mazebank"] = {
        "pounder",
        "mule",
        "mule2",
        "mule3",
        "swift2",
        "volatus",
        "luxor2",
    },
    ["garage_centro"] = {
        "pounder",
        "mule",
        "mule2",
        "mule3",
        "swift2",
        "volatus",
        "luxor2",
    },
    ["wine"] = {
        "pounder",
        "mule",
        "mule2",
        "mule3",
        "swift2",
        "volatus",
        "luxor2",
    },
    ["luxuosa"] = {
        "pounder",
        "mule",
        "mule2",
        "mule3",
        "swift2",
        "volatus",
        "luxor2",
    },
}



--########################################
--### PEGAR TUNAGEM ######################
--########################################

function InfoTuning(user_id,veiculo)
    return json.decode(vRP.getSData("custom:u"..user_id.."veh_"..veiculo) or {}) or {}
end

--########################################--

function PaymentGarage(source,payment)                               
    local user_id = vRP.getUserId(source)
	if vRP.request(source,"Deseja alugar o veiculo por R$"..payment.."?",30) then
        return vRP.tryFullPayment(parseInt(user_id),payment)
    end
end

