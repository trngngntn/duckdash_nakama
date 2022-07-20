-- Modifier class definition ----------------------------------------------------------------------
Effect = {
    id,
    desc = "",
    min_intensity_value = 0,
    max_intensity_value = 0,
    intensity_calculator = nil,
    rank_weight = 0,
    rank_calculator = nil
}

function Effect:new(o, id, desc, min_intensity_value, max_intensity_val, intensity_calculator, rank_weight,
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

function Effect:calculate_intensity(intensity)
    return self.intensity_calculator(intensity)
end

function Effect:calculate_rank(intensity)
    return self.rank_calculator(intensity)
end

EFF_LIST = {}

-- Effects definition ---------------------------------------------------------------------------

function std_intensity_cal(input_value)
    if input_value < 10 then
        return (10 - input_value) * -10
    end
    return (input_value - 10) * 10
end

function std_rank_cal(raw_intensity)
    return raw_intensity - 10
end


