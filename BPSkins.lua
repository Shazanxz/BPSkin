script_name = "BPSkins"
script_author = "Shazanxz"

local imgui = require 'imgui'
local encoding = require 'encoding'
local vkeys = require 'vkeys'

encoding.default = 'CP1251'
local u8 = encoding.UTF8

-- Cores Estilo Shox
local SHOX_PURPLE = imgui.ImVec4(0.69, 0.24, 1.00, 1.00) 
local SHOX_DARK   = imgui.ImVec4(0.12, 0.12, 0.12, 1.00) 
local SHOX_GREEN  = imgui.ImVec4(0.00, 1.00, 0.50, 1.00)

-- CORES DAS ORGANIZAÇÕES
local CL_GOV      = imgui.ImVec4(0.35, 0.55, 0.95, 1.00) -- Azul (PM/Exército/BOPE)
local CL_MED      = imgui.ImVec4(0.85, 0.85, 0.85, 1.00) -- Cinza (Médicos)
local CL_GOV_VERD = imgui.ImVec4(0.00, 0.75, 0.45, 1.00) -- Verde Água (Governo)
local CL_GANG_AZU = imgui.ImVec4(0.25, 0.45, 0.95, 1.00) -- Azul (Aztecas)
local CL_GANG_PCC = imgui.ImVec4(0.60, 0.60, 0.60, 1.00) -- Cinza (PCC)
local CL_GANG_GRO = imgui.ImVec4(0.00, 1.00, 0.00, 1.00) -- Verde (Groove)
local CL_GANG_BAL = imgui.ImVec4(0.70, 0.30, 1.00, 1.00) -- Roxo (Ballas)
local CL_GANG_VAG = imgui.ImVec4(1.00, 1.00, 0.00, 1.00) -- Amarelo (Vagos)
local CL_GANG_CV  = imgui.ImVec4(1.00, 0.15, 0.15, 1.00) -- Vermelho (CV)
local CL_MAFIA    = imgui.ImVec4(0.00, 0.85, 0.85, 1.00) -- Ciano (Máfias)
local CL_TERROR   = imgui.ImVec4(0.65, 0.15, 0.15, 1.00) -- Vinho (Terroristas)
local CL_MERC     = imgui.ImVec4(0.85, 0.35, 0.35, 1.00) -- Salmão (Mercenários)
local CL_ASSASSIN = imgui.ImVec4(0.55, 0.55, 0.55, 1.00) -- Cinza Escuro (Triads/Hitman)
local CL_NEUTRA   = imgui.ImVec4(1.00, 0.40, 0.40, 1.00) -- Vermelho Claro (Globo)




-- Variáveis de Controle
local menu_open = imgui.ImBool(false)
local selected_tab = 1
local search_id = imgui.ImBuffer(10)
local search_result = nil
local history = {} 
local skin_texture = nil 


--- BANCO DE DADOS
local skins_db = {
    -- ================================== ORGANIZAÇÕES (ORGs) ===============================
    -- GROOVE
    [107] = {modelo = "Groove com Bone", cat = "ORG", org_nome = "GROOVE STREET", cargo = "Cargo 1", modelsa = "fam3"},
    [105] = {modelo = "Groove com Bandana", cat = "ORG", org_nome = "GROOVE STREET", cargo = "Cargo 2", modelsa = "fam1"},
    [106] = {modelo = "Groove com Camisa Xadrez", cat = "ORG", org_nome = "GROOVE STEET", cargo = "Cargo 3", modelsa = "fam2"},
    [195] = {modelo = "Groove Feminina", cat = "ORG", org_nome = "GROVE STREET", cargo = "-", modelsa = "wfygraf"}, 
    [271] = {modelo = "Ryder", cat = "ORG", org_nome = "GROOVE STREET", cargo = "Cargo 4", modelsa = "ryder"},
    [269] = {modelo = "BigSmoke", cat = "ORG", org_nome = "GROOVE STREET", cargo = "Sublider 1 e 2", modelsa = "smoke"},
    [270] = {modelo = "Sweet", cat = "ORG", org_nome = "GROOVE STREET", cargo = "Lider", modelsa = "sweet"},
    -- BALLAS
    [102] = {modelo = "Ballas com bandana", cat = "ORG", org_nome = "BALLAS", cargo = "Cargo 1 e 2", modelsa = "ballas1"},
    [103] = {modelo = "Ballas com jaqueta preta", cat = "ORG", org_nome = "BALLAS", cargo = "Cargo 3 e 4", modelsa = "ballas2"},
    [104] = {modelo = "Ballas com touca preta", cat = "ORG", org_nome = "BALLAS", cargo = "Sublider e Lider", modelsa = "ballas3"},
    [13] = {modelo = "Ballas Feminina", cat = "ORG", org_nome = "BALLAS", cargo = "-", modelsa = "bfyri"},
    -- VAGOS
   [109] = {modelo = "Vagos com bandana", cat = "ORG", org_nome = "LOS VAGOS", cargo = "Cargo 1 e 2", modelsa = "lsv2"},
    [110] = {modelo = "Vagos com chinelo", cat = "ORG", org_nome = "LOS VAGOS", cargo = "Cargo 3 e 4", modelsa = "lsv3"},
    [108] = {modelo = "Vagos sem camisa", cat = "ORG", org_nome = "LOS VAGOS", cargo = "Sublider 1 e 2 e Lider", modelsa = "lsv1"},
    [215] = {modelo = "Vagos Feminina", cat = "ORG", org_nome = "LOS VAGOS", cargo = "-", modelsa = "vbfycr"},
    -- AZTECAS
    [114] = {modelo = "Azteca com bandana", cat = "ORG", org_nome = "LOS AZTECAS", cargo = "Cargo 1", modelsa = "vla1"},
    [116] = {modelo = "Azteca com blusa branca", cat = "ORG", org_nome = "LOS AZTECAS", cargo = "Cargo 2", modelsa = "vla3"},
    [174] = {modelo = "Azteca com colete", cat = "ORG", org_nome = "LOS AZTECAS", cargo = "Cargo 3", modelsa = "sbmotr2"},
    [173] = {modelo = "Azteca com chapeuzinho", cat = "ORG", org_nome = "LOS AZTECAS", cargo = "Cargo 4", modelsa = "sbmotr1"},
    [115] = {modelo = "Azteca com bone para tras ", cat = "ORG", org_nome = "LOS AZTECAS", cargo = "Sublider 1, 2 e Lider", modelsa = "vla2"},
    [226] = {modelo = "Azteca Feminina", cat = "ORG", org_nome = "LOS AZTECAS", cargo = "-", modelsa = "swfystra"},
    -- EXERCITO
   [287] = {modelo = "Militar", cat = "ORG", org_nome = "EXERCITO", cargo = "Cargo 1, 2, 3, 4 e Sublideres", modelsa = "army"},
    [73] = {modelo = "Militar com bandana", cat = "ORG", org_nome = "EXERCITO", cargo = "Lider", modelsa = "jizzy"},
    [191] = {modelo = "Militar Feminina", cat = "ORG", org_nome = "EXERCITO", cargo = "-", modelsa = "wfygaer"},
    -- BOPE | ROTA
    [285] = {modelo = "Swat", cat = "ORG", org_nome = "BOPE/ROTA/PRF", cargo = "Cargo 1, 2, 3, 4", modelsa = "swat"},
    [240] = {modelo = "Homem com colete", cat = "ORG", org_nome = "BOPE/ROTA/POLICIA CIVIL", cargo = "Sublideres", modelsa = "swmyhp2"},
    [171] = {modelo = "Homem com gravata borboleta ", cat = "ORG", org_nome = "BOPE/ROTA", cargo = "Lider", modelsa = "jethro"},
    [307] = {modelo = "Policial Feminina", cat = "ORG", org_nome = "BOPE/ROTA", cargo = "-", modelsa = "lapdfy1"},
    -- PCC
   [177] = {modelo = "Homem com blusa azul claro", cat = "ORG", org_nome = "PCC", cargo = "Cargo 1, 2, 3, 4 e Sublideres", modelsa = "sbmytr3"},
    [143] = {modelo = "Homem com jaqueta azul claro", cat = "ORG", org_nome = "PCC", cargo = "Lider", modelsa = "cwmyfr"},
    -- POLICIA FEDERAL
    [286] = {modelo = "Oficial FBI", cat = "ORG", org_nome = "POLICIA FEDERAL", cargo = "Cargo 1, 2, 3, 4", modelsa = "fbi"},
    [185] = {modelo = "Oficial Camisa Listrada", cat = "ORG", org_nome = "POLICIA FEDERAL E POLICIA CIVIL", cargo = "Sublideres", modelsa = "swmyri"},
    [295] = {modelo = "Homem com gravata vermelha", cat = "ORG", org_nome = "POLICIA FEDERAL", cargo = "Lider", modelsa = "fwmyst"},
    [224] = {modelo = "Policial Feminina com camisa de oncinha", cat = "ORG", org_nome = "POLICIA FEDERAL", cargo = "-", modelsa = "swfystr"},
    -- POLICIA MILITAR
    [280] = {modelo = "Policial Simples", cat = "ORG", org_nome = "POLICIA MILITAR", cargo = "Cargo 1", modelsa = "lapd1"},
    [281] = {modelo = "Policial com Bigode", cat = "ORG", org_nome = "POLICIA MILITAR", cargo = "Cargo 2", modelsa = "sfpd1"},
    [282] = {modelo = "Policial com Farda Clara", cat = "ORG", org_nome = "POLICIA MILITAR", cargo = "Cargo 3", modelsa = "lvpd1"},
    [288] = {modelo = "Policial com Farda e Chapeu Claro", cat = "ORG", org_nome = "POLICIA MILITAR", cargo = "Cargo 4", modelsa = "csher"},
    [266] = {modelo = "Pulanski", cat = "ORG", org_nome = "POLICIA MILITAR", cargo = "Sublideres", modelsa = "pulaski"},
    [267] = {modelo = "Tenpenny", cat = "ORG", org_nome = "POLICIA MILITAR", cargo = "Lider", modelsa = "tenpen"},
    [306] = {modelo = "Policia Feminina", cat = "ORG", org_nome = "POLICIA MILITAR", cargo = "-", modelsa = "lapdfy2"},
    -- PRF
    [290] = {modelo = "Homem com jaqueta preta e oculos", cat = "ORG", org_nome = "PRF", cargo = "Sublideres", modelsa = "rose"},
    [227] = {modelo = "Velho com terno", cat = "ORG", org_nome = "PRF e GLOBO", cargo = "Lider / Sublider e Lider GLOBO", modelsa = "swmotr2"},
    [298] = {modelo = "Policial Feminina", cat = "ORG", org_nome = "PRF", cargo = "-", modelsa = "vbfystp"},
    -- MEDICOS
    [275] = {modelo = "Medico Pardo", cat = "ORG", org_nome = "Medico", cargo = "Cargo 1 e 2", modelsa = "lvemt1"},
    [276] = {modelo = "Medico Branco", cat = "ORG", org_nome = "Medico", cargo = "Cargo 3", modelsa = "sfemt1"},
    [274] = {modelo = "Medico Negro", cat = "ORG", org_nome = "Medico", cargo = "Cargo 4", modelsa = "laemt1"},
    [70] = {modelo = "Medico com jaleco branco", cat = "ORG", org_nome = "Medico", cargo = "Sublideres e Lider", modelsa = "scientist"},
    -- GOVERNO
    [163] = {modelo = "Seguranca Negro", cat = "ORG", org_nome = "GOVERNO", cargo = "Cargo 1 e 2", modelsa = "bmyboun"},
    [164] = {modelo = "Seguranca Branco", cat = "ORG", org_nome = "GOVERNO", cargo = "Cargo 3 e 4", modelsa = "wmyboun"},
    [228] = {modelo = "Homem com terno e gravata vermelha", cat = "ORG", org_nome = "GOVERNO", cargo = "Sublideres", modelsa = "somori"},
    [147] = {modelo = "Homem com terno cinza", cat = "ORG", org_nome = "GOVERNO", cargo = "Lider", modelsa = "wmybu"},
    [150] = {modelo = "Mulher Empresaria", cat = "ORG", org_nome = "GOVERNO", cargo = "-", modelsa = "wfybu"},
    -- POLICIA CIVIL
    [124] = {modelo = "Homem vestido de preto", cat = "ORG", org_nome = "POLICIA CIVIL / AL-QAEDA", cargo = "Cargo 3", modelsa = "vmaff1"},
    [299] = {modelo = "Homem de jaqueta/Niko belic", cat = "ORG", org_nome = "POLICIA CIVIL / AL-QAEDA", cargo = "Cargo 4", modelsa = "claude"},
    [186] = {modelo = "Homem com terno cinza aberto", cat = "ORG", org_nome = "POLICIA CIVIL / AL-QAEDA", cargo = "Lider", modelsa = "somyri"},
    [141] = {modelo = "Japonesa", cat = "ORG", org_nome = "POLICIA CIVIL / AL-QAEDA", cargo = "-", modelsa = "sofybu"},
    -- COMANDO VERMELHO
    [142] = {modelo = "Homem com camisa hippie", cat = "ORG", org_nome = "COMANDO VERMELHO", cargo = "Cargo 2", modelsa = "swmyhp1"},
    [182] = {modelo = "Homem Punk", cat = "ORG", org_nome = "COMANDO VERMELHO", cargo = "Cargo 1", modelsa = "gormy"},
    [193] = {modelo = "Mulher com top vermelho", cat = "ORG", org_nome = "COMANDO VERMELHO", cargo = "-", modelsa = "wfypro"},
    [293] = {modelo = "OGLOC / Homem Tatuado sem camisa", cat = "ORG", org_nome = "COMANDO VERMELHO", cargo = "Cargo 3", modelsa = "ogloc"},
    [22] = {modelo = "Homem com moletom laranja", cat = "ORG", org_nome = "COMANDO VERMELHO", cargo = "Cargo 4", modelsa = "bmyst"},
    [19] = {modelo = "Homem sem camisa com roupa vermelha", cat = "ORG", org_nome = "COMANDO VERMELHO", cargo = "Lider", modelsa = "bmydj"},
    [49] = {modelo = "Velho com roupa vermelha e preta", cat = "ORG", org_nome = "COMANDO VERMELHO", cargo = "Sublideres", modelsa = "somyst"},
    -- MAFIA YAKUZA
    [111] = {modelo = "Homem com terno", cat = "ORG", org_nome = "MAFIA YAKUZA", cargo = "Cargo 3", modelsa = "maffa"},
    [208] = {modelo = "Japones com terno", cat = "ORG", org_nome = "MAFIA YAKUZA", cargo = "Cargo 1", modelsa = "suzie"},
    [117] = {modelo = "Homem magro com terno", cat = "ORG", org_nome = "MAFIA YAKUZA", cargo = "Sublideres", modelsa = "triada"},
    [120] = {modelo = "Homem com terno acinzentado", cat = "ORG", org_nome = "MAFIA YAKUZA", cargo = "Lider", modelsa = "triboss"},
    [203] = {modelo = "Homem com kimono com faixa vermelha", cat = "ORG", org_nome = "MAFIA YAKUZA", cargo = "Cargo 2", modelsa = "omykara"},
    [204] = {modelo = "Homem com barba e com kimono de faixa vermelha", cat = "ORG", org_nome = "MAFIA YAKUZA", cargo = "Cargo 4", modelsa = "wmykara"},
    [169] = {modelo = "Mulher com vestido preto", cat = "ORG", org_nome = "MAFIA YAKUZA", cargo = "-", modelsa = "sofyri"},
    -- MAFIA CN
     [126] = {modelo = "Homem com camisa longa azul", cat = "ORG", org_nome = "MAFIA CN", cargo = "Cargo 4", modelsa = "vbi"},
    [113] = {modelo = "Homem com barba e com smoking cinza", cat = "ORG", org_nome = "MAFIA CN", cargo = "Lider", modelsa = "maffb"},
    [43] = {modelo = "Homem com camisa lilas e oculos", cat = "ORG", org_nome = "MAFIA CN", cargo = "Sublideres", modelsa = "hmyst"},
    [192] = {modelo = "Mulher com regata", cat = "ORG", org_nome = "MAFIA CN", cargo = "-", modelsa = "wfyjg"},
    [223] = {modelo = "Homem com camisa longa rosa", cat = "ORG", org_nome = "MAFIA CN", cargo = "Cargo 2 e 3", modelsa = "sbmyst"},
    [46] = {modelo = "Homem com camisa longa branca", cat = "ORG", org_nome = "MAFIA CN", cargo = "Cargo 1", modelsa = "hmyri"},
    -- MAFIA MEXICANA
    [83] = {modelo = "Homem com roupa branca / Elvis Branco", cat = "ORG", org_nome = "MAFIA MEXICANA", cargo = "Cargo 1, 2, 3, 4", modelsa = "vhmycl"},
    [84] = {modelo = "Homem com roupa azul / Elvis Azul", cat = "ORG", org_nome = "MAFIA MEXICANA", cargo = "Sublideres e Lider", modelsa = "vbmycl"},
    [64] = {modelo = "Mulher com roupa curta", cat = "ORG", org_nome = "MAFIA MEXICANA", cargo = "-", modelsa = "vfyshere"},
    -- MAFIA RUSSA
    [77] = {modelo = "Mulher com chapeu grande rosa e desarrumada", cat = "ORG", org_nome = "MAFIA RUSSA e EMPREGO LIXEIRO FEMININA", cargo = "-", modelsa = "swmotr1"},
    [206] = {modelo = "Homem com blusa verde", cat = "ORG", org_nome = "MAFIA RUSSA / MAYANS", cargo = "Sublideres e Lider", modelsa = "vwmycd"},
    -- TALIBAN
    [121] = {modelo = "Homem careca com blusa branca", cat = "ORG", org_nome = "TALIBAN", cargo = "Cargo 1, 3", modelsa = "da_nanh"},
    [249] = {modelo = "Homem com sobretudo com pelo e chapeu", cat = "ORG", org_nome = "TALIBAN", cargo = "Sublideres e Lider", modelsa = "pimp"},
    [112] = {modelo = "Homem com casaco", cat = "ORG", org_nome = "TALIBAN", cargo = "Cargo 2", modelsa = "maffa"},
    [131] = {modelo = "Mulher com blusa marrom", cat = "ORG", org_nome = "TALIBAN", cargo = "-", modelsa = "wfypt"},
    [122] = {modelo = "Homem com blusa preta e touca preta", cat = "ORG", org_nome = "TALIBAN", cargo = "Cargo 4", modelsa = "da_glsh"},
    -- SONS
    [247] = {modelo = "Motoqueiro", cat = "ORG", org_nome = "SONS OF ANARCHY", cargo = "Cargo 1, 2, 3, 4", modelsa = "bikera"},
    [248] = {modelo = "Motoqueiro com bandana na cabeca", cat = "ORG", org_nome = "SONS OF ANARCHY", cargo = "Sublideres", modelsa = "bikerb"},   
    [100] = {modelo = "Motoqueiro com oculos", cat = "ORG", org_nome = "SONS OF ANARCHY ", cargo = "Lider ", modelsa = "wmycr"},
    [238] = {modelo = "Mulher semi nua com roupa vermelha", cat = "ORG", org_nome = "SONS OF ANARCHY ", cargo = "-", modelsa = "sbfypro"},
    -- MAYANS
    [132] = {modelo = "Velho Motoqueiro", cat = "ORG", org_nome = "MAYANS", cargo = "Cargo 3", modelsa = "somyst"},
    [291] = {modelo = "Homem de Jaqueta Jeans", cat = "ORG", org_nome = "MAYANS", cargo = "Cargo 4 ", modelsa = "truth"},
    [242] = {modelo = "Gordo com camisa branca", cat = "ORG", org_nome = "MAYANS", cargo = "Sublideres", modelsa = "swmyhp3"},
    [241] = {modelo = "Gordo com camisa preta", cat = "ORG", org_nome = "MAYANS", cargo = "Lider", modelsa = "skmyhp1"},
    [201] = {modelo = "Caminhoneira", cat = "ORG", org_nome = "MAYANS", cargo = "-", modelsa = "wfytruck"},
    -- HITMANS/TRIADS
   [166] = {modelo = "Homem de terno negro", cat = "ORG", org_nome = "HITMANS/TRIADS", cargo = "Cargo 1, 2 | ate Cargo 4 Triads", modelsa = "vbmyst"},
    [165] = {modelo = "Homem branco de terno ", cat = "ORG", org_nome = "HITMANS", cargo = "Cargo 3, 4", modelsa = "vwmyst"},
    [127] = {modelo = "Homem com jaqueta marrom", cat = "ORG", org_nome = "HITMANS/TRIADS", cargo = "Sublideres", modelsa = "triboss"},
    [294] = {modelo = "Woozie", cat = "ORG", org_nome = "HITMANS/TRIADS", cargo = "Lider", modelsa = "woozie"},
    [93] = {modelo = "Mulher de blusa preta e calca jeans", cat = "ORG", org_nome = "HITMANS/TRIADS", cargo = "-", modelsa = "wfypro"},
    -- REDE GLOBO (REPORTERES)
   [188] = {modelo = "Homem de blusa verde", cat = "ORG", org_nome = "GLOBO", cargo = "Cargo 1, 2", modelsa = "surly"},
    [156] = {modelo = "Velho de blusa azul / Barbeiro do CJ", cat = "ORG", org_nome = "GLOBO", cargo = "Cargo 3, 4", modelsa = "bmdibi"},
    [148] = {modelo = "Mulher casual azul", cat = "ORG", org_nome = "GLOBO", cargo = "-", modelsa = "wfylve"},
   
    -- ============================== EMPREGOS ==============================================
    [155]   = {modelo = "PizzaBoy", cat = "EMPREGO", modelsa = "wmypizz"},
    [205]   = {modelo = "PizzaGirl", cat = "EMPREGO", modelsa = "wfyburg"},
    [71]    = {modelo = "Agente Penitenciario", cat = "EMPREGO", modelsa = "wmysgrd"},
    [194]   = {modelo = "Agente Penitenciaria", cat = "EMPREGO", modelsa = "crogrl3"},
    [133]   = {modelo = "Caminhoneiro", cat = "EMPREGO", modelsa = "dnmolc2"},
    [20]    = {modelo = "Motorista de Onibus", cat = "EMPREGO", modelsa = "bmyri"},
    [61]    = {modelo = "Taxista", cat = "EMPREGO", modelsa = "wmyplt"},
    [40]    = {modelo = "Taxista - Feminina", cat = "EMPREGO", modelsa = "hfyri"},
    [263]   = {modelo = "Entregadora de produtos", cat = "EMPREGO", modelsa = "vwfywa2"},
    [260]   = {modelo = "Lixeiro", cat = "EMPREGO", modelsa = "bmycon"},
    [158]   = {modelo = "Fazendeiro", cat = "EMPREGO", modelsa = "cwmofr"},
    [68]    = {modelo = "Coveiro", cat = "EMPREGO", modelsa = "wmoprea"},
    [98]    = {modelo = "Carteiro", cat = "EMPREGO", modelsa = "wmyri"},
    [16]    = {modelo = "Eletricista", cat = "EMPREGO", modelsa = "bmyap"},
    [27]    = {modelo = "Operario de Construção", cat = "EMPREGO", modelsa = "wmycon"},
    [187]   = {modelo = "Advogado", cat = "EMPREGO", modelsa = "somybu"},
    [76]    = {modelo = "Advogada", cat = "EMPREGO", modelsa = "wfystew"},    
    -- ========================= LOJA DE ROUPAS ========================================
    [160]   = {modelo = "Caipira", cat = "LOJA DE ROUPAS", modelsa = "cwmohb2"},
    [2]     = {modelo = "Maccer", cat = "LOJA DE ROUPAS", modelsa = "maccer"},
    [1]     = {modelo = "The Truth", cat = "LOJA DE ROUPAS", modelsa = "truth"},
    [196]   = {modelo = "Habitante Rural", cat = "LOJA DE ROUPAS", modelsa = "cwfofr"},
    [214]   = {modelo = "Garçonete (Maria Latore)", cat = "LOJA DE ROUPAS", modelsa = "vwfywai"},
    [198]   = {modelo = "Habitante Rural Feminina", cat = "LOJA DE ROUPAS", modelsa = "cwfyfr1"},
    [201]   = {modelo = "Fazendeira", cat = "LOJA DE ROUPAS", modelsa = "dwfylc2"},
    [140]   = {modelo = "Visitante de Praia Feminina", cat = "LOJA DE ROUPAS", modelsa = "hfybe"},
    [138]   = {modelo = "Visitante de Praia Feminina 2", cat = "LOJA DE ROUPAS", modelsa = "wfybe"},
    [41]    = {modelo = "Pedestre Comum Feminina", cat = "LOJA DE ROUPAS", modelsa = "hfyst"},
    [56]    = {modelo = "Pedestre Comum Feminina 2 e Feminina Medicos", cat = "LOJA DE ROUPAS", modelsa = "ofyst"},
    [38]    = {modelo = "Pedestre Comum Feminina 3", cat = "LOJA DE ROUPAS", modelsa = "hfori"},
    [31]    = {modelo = "Habitante de Vila Feminina", cat = "LOJA DE ROUPAS", modelsa = "dwfolc"},
    [12]    = {modelo = "Mulher Rica", cat = "LOJA DE ROUPAS", modelsa = "bfyri"},
    [11]    = {modelo = "Crupie de Cassino", cat = "LOJA DE ROUPAS", modelsa = "vbfycrp"},
    [297]   = {modelo = "Madd Dogg", cat = "LOJA DE ROUPAS", modelsa = "maddogg"},
    [292]   = {modelo = "Cesar Vialpando", cat = "LOJA DE ROUPAS", modelsa = "cesar"},
    [289]   = {modelo = "Zero", cat = "LOJA DE ROUPAS", modelsa = "zero"},
    [259]   = {modelo = "Espectador 2", cat = "LOJA DE ROUPAS", modelsa = "heck2"},
    [258]   = {modelo = "Espectador 1", cat = "LOJA DE ROUPAS", modelsa = "heck1"},
    [159]   = {modelo = "Caipira de Macacão", cat = "LOJA DE ROUPAS", modelsa = "cwmohb1"},
    [21]     = {modelo = "Pedestre Afro-americano (Casual)", cat = "LOJA DE ROUPAS", modelsa = "bmyst"},
    [7]      = {modelo = "Pedestre Casual", cat = "LOJA DE ROUPAS", modelsa = "bmyst"},
    [170]   = {modelo = "Pedestre Comum", cat = "LOJA DE ROUPAS", modelsa = "somyst"},
    [180]   = {modelo = "Tatuador", cat = "LOJA DE ROUPAS", modelsa = "bmytatt"},
    [221]   = {modelo = "Pedestre Masculino", cat = "LOJA DE ROUPAS", modelsa = "sbmori"},
    [222]   = {modelo = "Pedestre Masculino 2", cat = "LOJA DE ROUPAS", modelsa = "sbmost"},
    [230]   = {modelo = "Morador de Rua", cat = "LOJA DE ROUPAS", modelsa = "swmotr5"},
    [250]   = {modelo = "Pedestre Comum Masculino", cat = "LOJA DE ROUPAS", modelsa = "swmycr"},
    [252]   = {modelo = "Manobrista Nu", cat = "LOJA DE ROUPAS", modelsa = "wmyva2"},
    [97]    = {modelo = "Salva-vidas", cat = "LOJA DE ROUPAS", modelsa = "wmylg"},
    [99]    = {modelo = "Patinador", cat = "LOJA DE ROUPAS", modelsa = "wmyro"},
    [119]   = {modelo = "Johnny Sindacco", cat = "LOJA DE ROUPAS", modelsa = "sindaco"},
    [14]    = {modelo = "Pedestre Afro-americano", cat = "LOJA DE ROUPAS", modelsa = "bmori"},
    [29]    = {modelo = "Traficante (San Fierro)", cat = "LOJA DE ROUPAS", modelsa = "wmydrug"},
    [35]    = {modelo = "Jardineiro", cat = "LOJA DE ROUPAS", modelsa = "hmogar"},
    [36]    = {modelo = "Jogador de Golfe 1", cat = "LOJA DE ROUPAS", modelsa = "wmygol1"},
    [37]    = {modelo = "Jogador de Golfe 2", cat = "LOJA DE ROUPAS", modelsa = "wmygol2"},
    [58]    = {modelo = "Pedestre Oriental", cat = "LOJA DE ROUPAS", modelsa = "omost"},
    [60]    = {modelo = "Pedestre Oriental 2", cat = "LOJA DE ROUPAS", modelsa = "omyst"},
    [62]    = {modelo = "Coronel Fuhrberger", cat = "LOJA DE ROUPAS", modelsa = "wmopj"},
    [67]    = {modelo = "Jogador de Bilhar", cat = "LOJA DE ROUPAS", modelsa = "bmypol2"},
    [86]    = {modelo = "Ryder (Mascara de Roubo)", cat = "LOJA DE ROUPAS", modelsa = "ryder3"},
    [95]    = {modelo = "Funcionário de Posto", cat = "LOJA DE ROUPAS", modelsa = "wmost"},
    [96]    = {modelo = "Corredor (Jogging)", cat = "LOJA DE ROUPAS", modelsa = "wmyjg"},
    [3]     = {modelo = "Andre", cat = "LOJA DE ROUPAS", modelsa = "andre"},
    [23]    = {modelo = "Ciclista BMX", cat = "LOJA DE ROUPAS", modelsa = "wmybmx"},
    [4]     = {modelo = "Big Bear (Magro)", cat = "LOJA DE ROUPAS", modelsa = "bbthin"},
    [26]    = {modelo = "Mochileiro", cat = "LOJA DE ROUPAS", modelsa = "wmybp"},
}

function loadSkinImage(id)
    local path = getWorkingDirectory() .. "\\resource\\BPSkinList\\" .. id .. ".png"
    if doesFileExist(path) then
        skin_texture = imgui.CreateTextureFromFile(path)
    else
        skin_texture = nil
    end
end

function clearSearch()
    search_id.v = ""
    search_result = nil
    skin_texture = nil
end

function getOrgColor(name)
    if not name then return imgui.ImVec4(1,1,1,1) end
    local n = name:upper()
    if n:find("POLICIA") or n:find("EXERCITO") or n:find("BOPE") or n:find("ROTA") or n:find("PRF") then return CL_GOV end
    if n:find("MEDICO") then return CL_MED end
    if n:find("GOVERNO") or n:find("DETRAN") then return CL_GOV_VERD end
    if n:find("AZTECAS") then return CL_GANG_AZU end
    if n:find("PCC") then return CL_GANG_PCC end
    if n:find("GROOVE") or n:find("GROVE") then return CL_GANG_GRO end
    if n:find("BALLAS") then return CL_GANG_BAL end
    if n:find("VAGOS") then return CL_GANG_VAG end
    if n:find("COMANDO VERMELHO") or n == "CV" then return CL_GANG_CV end
    if n:find("MAFIA") or n:find("YAKUZA") then return CL_MAFIA end
    if n:find("TALIBAN") or n:find("AL-QAEDA") then return CL_TERROR end
    if n:find("SONS") or n:find("MAYANS") then return CL_MERC end
    if n:find("HITMAN") or n:find("TRIADS") then return CL_ASSASSIN end
    if n:find("GLOBO") then return CL_NEUTRA end
    return imgui.ImVec4(1, 1, 1, 1)
end

function imgui.OnDrawFrame()
    if not menu_open.v then return end

    imgui.PushStyleColor(imgui.Col.WindowBg, SHOX_DARK)
    imgui.PushStyleColor(imgui.Col.TitleBgActive, SHOX_PURPLE)
    imgui.PushStyleVar(imgui.StyleVar.FrameRounding, 5.0)
    
    imgui.SetNextWindowSize(imgui.ImVec2(520, 420), imgui.Cond.FirstUseEver)
    imgui.Begin(u8"Skin Finder", menu_open)

    local btn_tab_size = imgui.ImVec2(162, 30)
    
    if selected_tab == 1 then imgui.PushStyleColor(imgui.Col.Button, SHOX_PURPLE) else imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.2, 0.2, 1)) end
    if imgui.Button(u8"Pesquisar", btn_tab_size) then selected_tab = 1 end
    imgui.PopStyleColor()
    imgui.SameLine()
    
    if selected_tab == 2 then imgui.PushStyleColor(imgui.Col.Button, SHOX_PURPLE) else imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.2, 0.2, 1)) end
    if imgui.Button(u8"Historico", btn_tab_size) then selected_tab = 2 end
    imgui.PopStyleColor()
    imgui.SameLine()

    if selected_tab == 3 then imgui.PushStyleColor(imgui.Col.Button, SHOX_PURPLE) else imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.2, 0.2, 0.2, 1)) end
    if imgui.Button(u8"Creditos", btn_tab_size) then selected_tab = 3 end
    imgui.PopStyleColor()

    imgui.Separator()
    imgui.Spacing()

    --- ABA PESQUISAR ---
    if selected_tab == 1 then
        imgui.Text(u8"ID da Skin:")
        imgui.PushItemWidth(120)
        imgui.InputText("##id", search_id, imgui.InputTextFlags.CharsDecimal)
        imgui.PopItemWidth()
        imgui.SameLine()
        
        if imgui.Button(u8"BUSCAR", imgui.ImVec2(80, 25)) then
            local id_num = tonumber(search_id.v)
            if id_num and skins_db[id_num] then
                search_result = skins_db[id_num]
                search_result.id = id_num
                loadSkinImage(id_num)
                table.insert(history, 1, {id = id_num, modelo = search_result.modelo})
                if #history > 10 then table.remove(history) end
            else
                search_result = "erro"
                skin_texture = nil
            end
        end

        imgui.SameLine()
        if imgui.Button(u8"LIMPAR", imgui.ImVec2(80, 25)) then
            clearSearch()
        end

        imgui.Spacing()
        imgui.Separator()
        imgui.Spacing()

        if search_result == "erro" then
            imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8"ID nao encontrado!")
        elseif type(search_result) == "table" then
            imgui.Columns(2, "res", false)
            imgui.SetColumnWidth(0, 320)

            imgui.TextColored(SHOX_PURPLE, u8"INFORMACOES DA SKIN:")
            imgui.Spacing()
            imgui.Text("ID: " .. search_result.id)
            imgui.Text(u8"MODELO: " .. search_result.modelo)
            imgui.TextColored(SHOX_GREEN, u8"CATEGORIA: " .. search_result.cat)
            
            if search_result.org_nome then
                imgui.Text(u8"ORGANIZACAO: ")
                imgui.SameLine()
                imgui.TextColored(getOrgColor(search_result.org_nome), u8(search_result.org_nome))
            end

            if search_result.cargo then
                imgui.Text(u8"CARGO: " .. search_result.cargo)
            end

            imgui.Text(u8"MODELO SA: " .. search_result.modelsa)

            imgui.NextColumn()

            if skin_texture then
                imgui.Image(skin_texture, imgui.ImVec2(160, 220))
            else
                imgui.BeginChild("noimg", imgui.ImVec2(160, 220), true)
                imgui.TextWrapped(u8"\n\n Sem Imagem\n BPSkinList/"..search_result.id..".png")
                imgui.EndChild()
            end
            imgui.Columns(1)
        else
            imgui.SetCursorPosY(imgui.GetCursorPosY() + 50)
            imgui.SetCursorPosX(imgui.GetWindowWidth()/2 - 80)
            imgui.TextDisabled(u8"Aguardando busca...")
        end

    --- ABA HISTÓRICO ---
    elseif selected_tab == 2 then
        imgui.TextColored(SHOX_PURPLE, u8"Historico de Pesquisa:")
        imgui.Spacing()
        if #history == 0 then
            imgui.Text(u8"Nenhuma busca recente.")
        else
            for i, item in ipairs(history) do
                if imgui.Selectable(string.format("[%d] ID: %d | %s", i, item.id, item.modelo)) then
                    search_id.v = tostring(item.id)
                    local data = skins_db[item.id]
                            if data then
                                search_result = {
                                     id = item.id,
                                                modelo = data.modelo,
                                                cat = data.cat,
                                                org_nome = data.org_nome,
                                                cargo = data.cargo,
                                                modelsa = data.modelsa
                                                 }
                                loadSkinImage(item.id)
                    end
                    selected_tab = 1
                end
            end
            imgui.Spacing()
            if imgui.Button(u8"Limpar Tudo", imgui.ImVec2(-1, 25)) then history = {} end
        end

    elseif selected_tab == 3 then
        imgui.TextColored(SHOX_PURPLE, u8"DESENVOLVEDOR PRINCIPAL:")
        imgui.BulletText("Shazanxz")
        
        imgui.Spacing()
        imgui.Separator()
        imgui.Spacing()
        
        imgui.TextColored(SHOX_GREEN, u8"CONTRIBUINTES:")
        imgui.BulletText(u8"Sanmy_CrysiS (Mapeamento de Skins)")
        imgui.BulletText(u8"Rickw (Mapeamento de Skins)")
        imgui.BulletText(u8"Daniel_Sykes (Mapeamento de Skins)")
        imgui.BulletText(u8"TheShadown (Auxilio das Imagens)")
        imgui.BulletText(u8"Open.mp (Documentacao de Skins)")
        
        imgui.Spacing()
        imgui.SetCursorPosY(imgui.GetWindowHeight() - 40)
        imgui.TextDisabled(u8"BPSkin - v1.0")
    end

    imgui.End()
    imgui.PopStyleVar()
    imgui.PopStyleColor(2)
end

function main()
    while not isSampAvailable() do wait(100) end
    clearSearch()
    sampRegisterChatCommand('skin', function() menu_open.v = not menu_open.v end)
    sampAddChatMessage("{B03DFF}[BPSkin]{FFFFFF} Script carregado! Use o comando {B03DFF}/skin {FFFFFF}para abrir o menu.", -1)
    while true do
        wait(0)
        imgui.Process = menu_open.v
    end
end