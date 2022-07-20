local nkm = require("nakama")
local modf = require("data.modules.equipment.modifier")
local eff = require("data.modules.equipment.effect")
local stats = require("data.modules.math.stats")

TYPE_WEAPON = 0x01
TYPE_WEAPON_SUB_TYPE = {}
TYPE_WEAPON_SUB_TYPE[0x1] = "POWER_PUNCH"
TYPE_WEAPON_SUB_TYPE[0x2] = "TERROR_SLASH"
TYPE_WEAPON_SUB_TYPE[0x3] = "MAGIC_BULLET"
TYPE_WEAPON_SUB_TYPE[0x4] = "ENERGY_BLADE"
TYPE_ARMOR = 0x02

TYPE_LIST = {}
TYPE_LIST[0x01] = "WEAPON"
TYPE_LIST[0x03] = "ARMOR"

BASE_FORMAT = 16
LENGTH_TYPE = 1
LENGTH_SUB_TYPE = 1
LENGTH_MODF_COUNT = 1
LENGTH_EFF_COUNT = 1
LENGTH_MODF_ID = 2
LENGTH_MODF_VAL = 2
LENGTH_EFF_ID = 2
LENGTH_EFF_VAL = 2

RANK_COMMON = {
    ["name"] = "COMMON",
    ["max"] = 25
}
RANK_UNCOMMON = {
    ["name"] = "UNCOMMON",
    ["max"] = 50
}
RANK_RARE = {
    ["name"] = "RARE",
    ["max"] = 75
}
RANK_EPIC = {
    ["name"] = "EPIC",
    ["max"] = 100
}
RANK_LEGENDARY = {
    ["name"] = "LEGENDARY",
    ["max"] = 125
}

-- Meta class
Equipment = {
    type_name = "",
    modf_count = 0,
    modf_list = nil,
    eff_count = 0,
    eff_list = nil
}

function Equipment:new(o, type_name, sub_type, modf_list, eff_list)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.type_name = type_name
    self.sub_type = sub_type
    self.modf_list = modf_list
    self.eff_list = eff_list
    return o
end

function Equipment:parse(str)
    pos = 1
    type = tonumber(string.sub(str, pos, pos + LENGTH_TYPE - 1), BASE_FORMAT)
    pos = pos + LENGTH_TYPE
    sub_type = nil
    if type == TYPE_WEAPON then
        sub_type = tonumber(string.sub(str, pos, pos + LENGTH_SUB_TYPE - 1), BASE_FORMAT)
        pos = pos + LENGTH_SUB_TYPE
    end
    modf_count = tonumber(sttring.sub(pos, pos + LENGTH_MODF_COUNT - 1), BASE_FORMAT)
    pos = pos + LENGTH_MODF_COUNT
    modf_list = {}
    if modf_count > 0 then
        for i = 1, modf_count, 1 do
            modf_list[i] = {}
            modf_list[i]["id"] = tonumber(sttring.sub(pos, pos + LENGTH_MODF_ID - 1), BASE_FORMAT)
            pos = pos + LENGTH_MODF_ID
            modf_list[i]["val"] = tonumber(sttring.sub(pos, pos + LENGTH_MODF_VAL - 1), BASE_FORMAT)
            pos = pos + LENGTH_MODF_VAL
        end
    end

    eff_count = tonumber(sttring.sub(pos, pos + LENGTH_EFF_COUNT - 1), BASE_FORMAT)
    pos = pos + LENGTH_EFF_COUNT
    eff_list = {}
    if eff_count > 0 then
        for i = 1, eff_count, 1 do
            eff_list[i] = {}
            eff_list[i]["id"] = tonumber(sttring.sub(pos, pos + LENGTH_EFF_ID - 1), BASE_FORMAT)
            pos = pos + LENGTH_EFF_ID
            eff_list[i]["val"] = tonumber(sttring.sub(pos, pos + LENGTH_EFF_ID - 1), BASE_FORMAT)
            pos = pos + LENGTH_EFF_ID
        end
    end

    return Equipment.new(nil, TYPE_LIST[type], sub_type, modf_list, eff_list)
end

function Equipment:to_json()
    json = {}
    json["type_name"] = self.type_name
    if not self.sub_type == nil then
        json["sub_type"] = self.sub_type
    end
    modf_list = {}
    for modifier in self.modf_list do
        modf_instance = modf.MODF_LIST[modifier["id"]]
        modf_list[modf_instance.id] = modf_instance.calculate_intensity(modifier["val"])
    end
    json["modifier"] = modf_list
    return nkm.encode_json(json)
end

function Equipment:get_rank()
    rank = 0
    for modifier in self.modf_list do
        modf_instance = modf.MODF_LIST[modifier["id"]]
        rank = rank + modf_instance.calculate_rank(modifier["val"])
    end
    for effect in self.eff_list do
        eff_instance = eff.EFF_LIST[effect["id"]]
        rank = rank + modf_instance.calculate_rank(effect["val"])
    end
    return rank
end

function Equipment:generate()

end
