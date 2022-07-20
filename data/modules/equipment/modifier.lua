local M = {}

-- Modifier class definition ----------------------------------------------------------------------
Modifier = {
    id,
    desc = "",
    min_intensity_value = 0,
    max_intensity_value = 0,
    intensity_calculator = nil,
    rank_weight = 0,
    rank_calculator = nil
}

function Modifier:new(o, id, desc, min_intensity_value, max_intensity_val, intensity_calculator, rank_weight,
    rank_calculator)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.id = id or ""
    self.decs = decs or "{}"
    self.min_intensity_value = min_intensity_value or 0x00
    self.max_max_intensity_valval = max_intensity_val or 0xff
    self.intensity_calculator = intensity_calculator or nil
    self.rank_weight = rank_weight or 0
    self.rank_calculator = rank_calculator or nil
    return o
end

function Modifier:calculate_intensity(intensity)
    return self.intensity_calculator(intensity)
end

function Modifier:calculate_rank(intensity)
    return self.rank_calculator(intensity)
end

M.MODF_LIST = {}
M.MODF_LIST[0x01] = MODF_DAMG
M.MODF_LIST[0x02] = MODF_ATK_SPD
M.MODF_LIST[0x03] = MODF_ATK_RANGE
M.MODF_LIST[0x04] = MODF_CRIT_CHANCE
M.MODF_LIST[0x05] = MODF_CRIT_MUL

-- Modifiers definition ---------------------------------------------------------------------------

function std_intensity_cal(input_value)
    if input_value < 10 then
        return (10 - input_value) * -10
    end
    return (input_value - 10) * 10
end

function std_rank_cal(raw_intensity)
    return raw_intensity - 10
end

---- Damage ---------------------------------------------------------------------------------------
MODF_DAMG = Modifier:new(nil, "DAMG", "{}% damage", 1, 35, std_intensity_cal, 1, std_intensity_cal)
---- Attack Speed ---------------------------------------------------------------------------------
MODF_ATK_SPD = Modifier:new(nil, "ATK_SPD", "{}% attack speed", 1, 35, std_intensity_cal, 1, std_intensity_cal)
---- Attack Range ---------------------------------------------------------------------------------
MODF_ATK_RANGE = Modifier:new(nil, "ATK_RANGE", "{}% attack range", 1, 35, std_intensity_cal, 1, std_intensity_cal)
---- Critical Change ------------------------------------------------------------------------------
MODF_CRIT_CHANCE = Modidier:new(nil, "CRIT_CHANCE", "{}% critical chance", 1, 35, std_intensity_cal, 1,
    std_intensity_cal)
---- Critical Multiply ----------------------------------------------------------------------------
MODF_CRIT_MUL = Modifier:new(nil, "CRIT_MUL", "{}x critical damage", 1, 35, std_intensity_cal, 1, std_intensity_cal)

-- local const
-- MODF_PROJ_NUM = Modifier:new(nil, "modf_proj_num", "+{} projectile(s)", 1, 5, "x", 1, "x")
-- local const
-- MODF_PROJ_SPD = Modifier:new(nil, "modf_proj_spd", "{}% projectile speed", 0, 1, "x", 1, "x")
-- local const
-- MODF_PROJ_PIERCE = Modifier:new(nil, "modf_proj_pierce", "+{} piercing", 0, 1, "x", 1, "x")

-- local const
-- MODF_LIFE_STEAL = Modidier:new(nil, "modf_life_steal", "{}% life steal")
-- local const
-- MODF_HP = Modidier:new(nil, "modf_hp", "{}% HP")
-- local const
-- MODF_ARMOR = Modidier:new(nil, "modf_armor", "{}% armor")

-- local const
-- MODF_MV_SPD = Modidier.new(nil, "modf_spd", "{}% movement speed")
-- local const
-- MODF_DASH_RANGE = Modidier.new(nil, "modf_dash_range", "{}% dash range")
-- local const
-- MODF_STBL = Modidier:new(nil, "modf_stbl", "{}% stability")

