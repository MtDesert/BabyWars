
local WarScene_Test1 = {
    warField = "WarField_Test1",

    turn = {
        turnIndex   = 1,
        playerIndex = 1,
        phase       = "standby",
    },

    players = {
        {
            id      = 1,
            name    = "Alice",
            fund    = 111111,
            energy  = 1,
            isAlive = true,
        },
        {
            id      = 2,
            name    = "Bob",
            fund    = 222222,
            energy  = 2,
            isAlive = true,
        },
    },
}

return WarScene_Test1
