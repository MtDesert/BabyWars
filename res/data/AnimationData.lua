
local AnimationData = {}

AnimationData.tileAnimations = {
    {tileType = "Plain",        shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    {tileType = "River",        shapesCount = 16, framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    {tileType = "Sea",          shapesCount = 47, framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    {tileType = "Beach",        shapesCount = 12, framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    {tileType = "Road",         shapesCount = 11, framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    {tileType = "Bridge",       shapesCount = 11, framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    {tileType = "Wood",         shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    {tileType = "Mountain",     shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    {tileType = "Wasteland",    shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    {tileType = "Ruins",        shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    {tileType = "Fire",         shapesCount = 1,  framesCount = 5, durationPerFrame = 0.1,    fillsGrid = true,  },
    {tileType = "Rough",        shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    {tileType = "Mist",         shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    {tileType = "Reef",         shapesCount = 1,  framesCount = 8, durationPerFrame = 0.2,    fillsGrid = true,  },
    {tileType = "Plasma",       shapesCount = 1,  framesCount = 3, durationPerFrame = 0.1,    fillsGrid = false, },
    {tileType = "Meteor",       shapesCount = 1,  framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
    {tileType = "Silo",         shapesCount = 2,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    {tileType = "Headquarters", shapesCount = 4,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    {tileType = "City",         shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    {tileType = "CommandTower", shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    {tileType = "Radar",        shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    {tileType = "Factory",      shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    {tileType = "Airport",      shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = true,  },
    {tileType = "Seaport",      shapesCount = 5,  framesCount = 2, durationPerFrame = 0.5,    fillsGrid = false, },
    {tileType = "TempAirport",  shapesCount = 5,  framesCount = 1, durationPerFrame = 999999, fillsGrid = true,  },
    {tileType = "TempSeaport",  shapesCount = 5,  framesCount = 1, durationPerFrame = 999999, fillsGrid = false, },
}

AnimationData.unitAnimations = {
    Infantry = {
        {
            normal = {pattern = "c02_t01_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t01_s05_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t01_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t01_s06_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t01_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t01_s07_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t01_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t01_s08_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
    },

    Mech = {
        {
            normal = {pattern = "c02_t02_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t02_s05_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t02_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t02_s06_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t02_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t02_s07_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t02_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t02_s08_f%02d.png", framesCount = 4, durationPerFrame = 0.11},
        },
    },

    Bike = {
        {
            normal = {pattern = "c02_t03_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t03_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t03_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t03_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t03_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t03_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t03_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t03_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Recon = {
        {
            normal = {pattern = "c02_t04_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t04_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t04_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t04_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t04_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t04_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t04_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t04_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Flare = {
        {
            normal = {pattern = "c02_t05_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t05_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t05_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t05_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t05_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t05_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t05_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t05_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    AntiAir = {
        {
            normal = {pattern = "c02_t06_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t06_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t06_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t06_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t06_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t06_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t06_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t06_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Tank = {
        {
            normal = {pattern = "c02_t07_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t07_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t07_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t07_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t07_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t07_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t07_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t07_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    MediumTank = {
        {
            normal = {pattern = "c02_t08_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t08_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t08_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t08_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t08_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t08_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t08_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t08_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    WarTank = {
        {
            normal = {pattern = "c02_t09_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t09_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t09_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t09_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t09_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t09_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t09_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t09_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Artillery = {
        {
            normal = {pattern = "c02_t10_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t10_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t10_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t10_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t10_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t10_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t10_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t10_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    AntiTank = {
        {
            normal = {pattern = "c02_t11_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t11_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t11_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t11_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t11_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t11_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t11_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t11_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Rockets = {
        {
            normal = {pattern = "c02_t12_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t12_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t12_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t12_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t12_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t12_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t12_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t12_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Missiles = {
        {
            normal = {pattern = "c02_t13_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t13_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t13_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t13_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t13_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t13_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t13_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t13_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Rig = {
        {
            normal = {pattern = "c02_t14_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t14_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t14_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t14_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t14_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t14_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t14_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t14_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Fighter = {
        {
            normal = {pattern = "c02_t15_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t15_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t15_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t15_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t15_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t15_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t15_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t15_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Bomber = {
        {
            normal = {pattern = "c02_t16_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t16_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t16_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t16_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t16_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t16_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t16_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t16_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Duster = {
        {
            normal = {pattern = "c02_t17_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t17_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t17_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t17_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t17_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t17_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t17_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t17_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    BattleCopter = {
        {
            normal = {pattern = "c02_t18_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t18_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t18_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t18_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t18_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t18_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t18_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t18_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    TransportCopter = {
        {
            normal = {pattern = "c02_t19_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t19_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t19_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t19_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t19_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t19_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t19_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t19_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Seaplane = {
        {
            normal = {pattern = "c02_t20_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t20_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t20_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t20_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t20_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t20_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t20_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t20_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Battleship = {
        {
            normal = {pattern = "c02_t21_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t21_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t21_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t21_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t21_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t21_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t21_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t21_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Carrier = {
        {
            normal = {pattern = "c02_t22_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t22_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t22_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t22_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t22_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t22_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t22_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t22_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Submarine = {
        {
            normal = {pattern = "c02_t23_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t23_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t23_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t23_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t23_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t23_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t23_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t23_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Cruiser = {
        {
            normal = {pattern = "c02_t24_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t24_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t24_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t24_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t24_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t24_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t24_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t24_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Lander = {
        {
            normal = {pattern = "c02_t25_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t25_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t25_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t25_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t25_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t25_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t25_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t25_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },

    Gunboat = {
        {
            normal = {pattern = "c02_t26_s01_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t26_s05_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t26_s02_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t26_s06_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t26_s03_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t26_s07_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
        {
            normal = {pattern = "c02_t26_s04_f%02d.png", framesCount = 4, durationPerFrame = 0.3},
            moving = {pattern = "c02_t26_s08_f%02d.png", framesCount = 3, durationPerFrame = 0.11},
        },
    },
}

return AnimationData
