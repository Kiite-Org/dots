local json = require("utils.json")
local default = require("scheme.default")

local home       = os.getenv("HOME")

local user_file = io.open(home .. "/.local/state/kiite/user/generated/colors.json", "r")

local function snake_to_camel(str)
    return str:gsub("(_)(%w)", function(_, match)
        return match:upper()
    end)
end

local function format_keys_to_camel(tbl)
    if not tbl then return nil end
    local camel_tbl = {}
    for key, value in pairs(tbl)
    do
        -- Format the key name if it's a string
        local new_key = type(key) == "string" and snake_to_camel(key) or key
        camel_tbl[new_key] = value
    end
    return camel_tbl
end

local function drop_hex_symbol(tbl)
    if not tbl then return nil end
    local formatted_tbl = {}
    for key, value in pairs(tbl)
    do
        -- Drop the # symbol from the Hex codes.
        formatted_tbl[key] = string.gsub(value, "#", "")
    end
    return formatted_tbl
end

if not user_file then
    return default
end

local content = user_file:read("*a")
user_file:close()

local parsed_json = json.decode(content)
local camel_json = format_keys_to_camel(parsed_json)
return drop_hex_symbol(camel_json)