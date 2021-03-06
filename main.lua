local function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function party_sort(a, b)
    if a.id == fft_me().id then
        return true
    elseif b.id == fft_me().id then
        return false
    end
    local job_order = fft_config_get("sort_order")
    ak = -1
    bk = -1
    for k, v in ipairs(job_order) do
        if string.upper(v) == string.upper(a.job) then
            ak = k
        end
        if string.upper(v) == string.upper(b.job) then
            bk = k
        end
    end
    return ak < bk
end

local function get_sorted_party()
    combatants = fft_combatants()
    table.sort(combatants, party_sort)
    return combatants
end

local function get_combatant_index(combatant)
    for k, v in ipairs(get_sorted_party()) do
        if v == combatant or v.name == combatant or v.id == combatant then
            return k
        end
    end
    fft_log_warn("Could not find keypress for '" .. combatant.name .. "'.")
    return -1
end

local function do_keypress(index)
    if index >= 1 then
        local keys = split(fft_config_get("key_map")[index], "-")
        fft_key_press(keys[1], keys[2], keys[3], keys[4])
    end
end

local function on_mark(combatant)
    do_keypress(get_combatant_index(combatant))
end

local function on_clear()
    local keys = split(fft_config_get("key_map")[9], "-")
    fft_key_press(keys[1], keys[2], keys[3], keys[4])
end

function init()
    fft_event_attach("am:mark", on_mark)
    fft_event_attach("am:clear", on_clear)
end

function info()
    return {
        name = "Auto Markers",
        desc = "Enables the use of auto player markers. Used for UWU Titan Jails (and maybe more)."
    }
end