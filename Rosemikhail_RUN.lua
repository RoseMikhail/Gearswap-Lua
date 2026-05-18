---@diagnostic disable: lowercase-global, undefined-global
include("Modes.lua")

----------------------------------------------------------------
-- NOTES
----------------------------------------------------------------

--[[
Maybe I need a toggle on whether TP mode also locks the weapon

Tanking mode could be made generic as a melee mode for when I set up actual melee jobs
- Note that this will also pave the way for low/high/etc main sets as well, not just weapon sets

If I want to extend "melee mode" TP etc into my caster jobs, maybe I'd need a general "do I go into melee mode when engaged" toggle.
This might then help me with setting up Mercurial pole funnies on BLM
]]

----------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------

-- Modes and toggles
melee_mode = M{"Physical", "Parrying", "Magical", "TP"}
idle_mode = M{"Normal"} -- TODO: Not sure if I'll even need different idle modes!
weapon_mode = M{"Aettir", "Epeolatry"}

toggle_speed = "Off"

-- Midcast helpers
-- Nothing as of yet

-- Bindings
send_command("bind f1 gs c meleemode")

send_command("bind f5 gs c weaponmode")
send_command("bind f6 gs c idlemode")

send_command("bind f9 gs c togglespeed")
send_command("bind f12 gs c toggletextbox")

-- Help Text
add_to_chat(123, "F1: Cycle tanking mode")
add_to_chat(123, "F5: Switch weapon set, F6: Cycle idle mode")
add_to_chat(123, "F9: Toggle speed gear")
add_to_chat(123, "F12: Hide information text box")

----------------------------------------------------------------
-- INFORMATION BOX
----------------------------------------------------------------

default_settings = {
  bg = { alpha = 0 },
  pos = { x = -35, y = -2 },
  flags = { draggable = false, right = true },
  text = { font = "Arial", size = 11, stroke = { width = 1}},
}

text_box = texts.new(default_settings)
text_box:visible(true)

function build_info_box()
    local function format_toggle(toggle)
        return toggle == "On" and "\\cs(0,255,0)On\\cr" or "\\cs(255,0,0)Off\\cr"
    end

    local output = string.format(
        "Tanking: %s, Wep: %s | Idle: %s | Speed: %s",
        melee_mode.current,
        weapon_mode.current,
        idle_mode.current,
        format_toggle(toggle_speed)
    )

    text_box:text(output)
end

build_info_box()

----------------------------------------------------------------
-- MISC INIT/COMMANDS
----------------------------------------------------------------

-- Lockstyle
function update_lockstyle()
    send_command("wait 5;input /lockstyleset 35") -- River
end

function update_macro_book()
    send_command("input /macro book 5;input /macro set 1")
end

update_lockstyle()
update_macro_book()

-- Individual spells should be added in the following way: sets.precast["Impact"]. This goes for precast and midcast.
function get_sets()
    ----------------------------------------------------------------
    -- GEAR PLACEHOLDERS
    ----------------------------------------------------------------
    
    jse = {}                       -- Leave this empty
    jse.AF = {}                    -- Leave this empty
    jse.relic = {}                 -- Leave this empty
    jse.empyrean = {}              -- Leave this empty
    jse.capes = {}                 -- Leave this empty

    jse.AF = {
        --head="",
        --body="",
        --hands="",
        --legs="",
        --feet="",
    }

    jse.relic = {
        --head="",
        --body="",
        --hands="",
        --legs="",
        --feet="",
    }

    jse.empyrean = {
        --head="",
        --body="",
        --hands="",
        --legs="",
        --feet="",
    }

    jse.capes = {
        --idle="",
    }

    ----------------------------------------------------------------
    -- WEAPON SETS
    ----------------------------------------------------------------
    
    -- Weapon Mode -> Tanking Mode 
    weapon_sets = {
        ["Aettir"] = { -- Higher accuracy option, better for tanking purely magical fights
            ["Physical"] = {
                main="Aettir",
                sub="Refined Grip +1",
            },
            ["Parrying"] = {
                main="Aettir",
                sub="Refined Grip +1",
            },
            ["Magical"] = {
                main="Aettir",
                sub="Irenic Strap +1",
            },
            ["TP"] = {
                main="Aettir",
                sub="Utu Grip",
            },
        },
        ["Epeolatry"] = { -- Better enmity, Liement aoe, PDT2
            ["Physical"] = {
                main="Epeolatry",
                sub="Refined Grip +1",
            },
            ["Parrying"] = {
                main="Epeolatry",
                sub="Refined Grip +1",
            },
            ["Magical"] = {
                main="Epeolatry",
                sub="Irenic Strap +1",
            },
            ["TP"] = {
                main="Epeolatry",
                sub="Utu Grip",
            },
        },
        -- Naegling
        -- Dolichenus
        -- Lycurgos
    }

    ----------------------------------------------------------------
    -- GEAR SETS
    ----------------------------------------------------------------
    
    sets = {}
    sets.precast = {}               -- Leave this empty
    sets.midcast = {}               -- Leave this empty
    sets.idle = {}                  -- Leave this empty
    sets.ja = {}                    -- Leave this empty
    sets.ws = {}                    -- Leave this empty
    sets.melee = {}                 -- Leave this empty
    sets.buff = {}                  -- Leave this empty

    ----------------------------------------------------------------
    -- IDLE MODES
    ----------------------------------------------------------------
    
    sets.idle["Normal"] = {
        range="",
        ammo="",
        head="",
        body="",
        hands="",
        legs="",
        feet="",
        neck="",
        waist="",
        left_ear="",
        right_ear="",
        left_ring="",
        right_ring="",
        back="",
    }

    ----------------------------------------------------------------
    -- MELEE "IDLE"
    ----------------------------------------------------------------

    sets.melee["Physical"] = {
        range="",
        ammo="",
        head="",
        body="",
        hands="",
        legs="",
        feet="",
        neck="",
        waist="",
        left_ear="",
        right_ear="",
        left_ring="",
        right_ring="",
        back="",
    }
    sets.melee["Parrying"] = {
        range="",
        ammo="",
        head="",
        body="",
        hands="",
        legs="",
        feet="",
        neck="",
        waist="",
        left_ear="",
        right_ear="",
        left_ring="",
        right_ring="",
        back="",
    }
    sets.melee["Magic"] = {
        range="",
        ammo="",
        head="",
        body="",
        hands="",
        legs="",
        feet="",
        neck="",
        waist="",
        left_ear="",
        right_ear="",
        left_ring="",
        right_ring="",
        back="",
    }

    -- I don't expect that I'll be using this much
    sets.melee["TP"] = {
        range="",
        ammo="",
        head="",
        body="",
        hands="",
        legs="",
        feet="",
        neck="",
        waist="",
        left_ear="",
        right_ear="",
        left_ring="",
        right_ring="",
        back="",
    }

    ----------------------------------------------------------------
    -- PRECAST
    ----------------------------------------------------------------

    sets.precast.fast_cast = set_combine(sets.idle["Normal"], {
    })

    -- With Inspiration, we could potentially have very easy fast cast
    -- Maybe have a check to decide between shitty fast cast vs inspiration fast cast

    ----------------------------------------------------------------
    -- ENMITY
    ----------------------------------------------------------------
    
    -- Potentially need an enmity mode
    -- Normal enmity vs safe enmity for fights that have encumbrance

    sets.midcast.enmity = {
        range="",
        ammo="",
        head="",
        body="",
        hands="",
        legs="",
        feet="",
        neck="",
        waist="",
        left_ear="",
        right_ear="",
        left_ring="",
        right_ring="",
        back="",

        -- Will this actually be midcast or precast? JAs and spells are different, after all.
    }

    sets.midcast.enmity_safe = {
        range="",
        ammo="",
        head="",
        body="",
        hands="",
        legs="",
        feet="",
        neck="",
        waist="",
        left_ear="",
        right_ear="",
        left_ring="",
        right_ring="",
        back="",

        -- Will this actually be midcast or precast? JAs and spells are different, after all.
    }

    sets.midcast["Foil"] = {
        -- Equip Futhark Trousers here
        -- Possibly inherit from enmity in general?
    }

    ----------------------------------------------------------------
    -- MAGIC
    ----------------------------------------------------------------
    
    sets.midcast["Enhancing Magic"] = {
        range="",
        ammo="",
        head="",
        body="",
        hands="",
        legs="",
        feet="",
        neck="",
        waist="",
        left_ear="",
        right_ear="",
        left_ring="",
        right_ring="",
        back="",
    }

    ----------------------------------------------------------------
    -- JOB ABILITIES 
    ----------------------------------------------------------------

    sets.ja["Vallation"] = {
        -- I unno
    }

    sets.ja["Valliance"] = {
        -- I unno
    }

    sets.ja["Battuta"] = {
        -- I unno
    }

    sets.ja["Rayke"] = {
        -- I unno
    }

    sets.ja["Gambit"] = {
        -- I unno
    }

    sets.ja["Swordplay"] = {
        -- I unno
    }

    sets.ja["Elemental Sforzo"] = {
        -- I unno
    }

    sets.ja["Liement"] = {
        -- I unno
    }

    ----------------------------------------------------------------
    -- WEAPONSKILLS 
    ----------------------------------------------------------------

    sets.ws.default = {
        range="",
        ammo="",
        head="",
        body="",
        hands="",
        legs="",
        feet="",
        neck="",
        waist="",
        left_ear="",
        right_ear="",
        left_ring="",
        right_ring="",
        back="",
    }
end

----------------------------------------------------------------
-- HELPER FUNCTIONS 
----------------------------------------------------------------

function equip_set_and_weapon(set)
    equip(set)

    -- This will only add the current weapon set to sets that have neither a main weapon or a sub (like a shield)
    if not set.main and not set.sub then
        equip(weapon_sets[weapon_mode.current][melee_mode.current])
        add_to_chat(123, string.format("Weapon mode: %s Tanking mode: %s", weapon_mode.current, melee_mode.current))
        return
    end
end

function idle()
    -- Choose between melee mode and regular idle
    if player.status == "Engaged" then
        equip_set_and_weapon(sets.melee[melee_mode.current])
    else
        equip_set_and_weapon(sets.idle[idle_mode.current])
    end

    -- Speed overlay
    if toggle_speed == "On" then
        equip({right_ring="Shneddick Ring",})
    end

    -- Runefencer buffs
    if buffactive["Embolden"] then
        equip({""}) -- Evasionist's cape
    end
end

function handle_toggle(toggle, label)
    local result = (toggle == "On") and "Off" or "On"
    add_to_chat(123, string.format("%s toggle: %s", label, result))
    return result
end

----------------------------------------------------------------
-- GEARSWAP FUNCTIONS
----------------------------------------------------------------
function precast(spell)

    --[[
    if toggle_speed == "On" then
        add_to_chat(123, "Consider disabling the speed toggle!")
    end
    ]]

    -- Somewhat redundant, but leftover from BLM's other paths
    local function equip_if_ja_match(spell_name)
        if sets.ja[spell_name] then
            equip_set_and_weapon(sets.ja[spell_name])
            return true
        end
        return false
    end

    -- If the job ability name matches.
    if equip_if_ja_match(spell.name) then
        return
    end

    -- If the weapon skill name matches.
    if sets.ws[spell.name] then
        equip_set_and_weapon(sets.ws[spell.name])

        -- Hachirin-no-Obi overlay. Do not apply this to Myrkr.
        if S{world.weather_element, world.day_element}:contains(spell.element) and spell.element ~= "None" and spell.name ~= "Myrkr" then
            equip({waist="Hachirin-no-Obi"})
        end

        return
    end

    -- Handling for both matched and unmatched magic spells
    if spell.action_type == "Magic" then
        if sets.precast[spell.name] then
            -- If the spell name matches.
            equip_set_and_weapon(sets.precast[spell.name])
        else
            -- General purpose
            equip_set_and_weapon(sets.precast.fast_cast)
        end

        return
    end

    -- Unhandled Job Abilities
    if spell.type == "JobAbility" or spell.type == "Scholar" then
        -- Stay in idle.
        return
    end

    -- Unhandled Weapon Skills
    if spell.action_type == "Ability" then
        equip_set_and_weapon(sets.ws.default)
        return
    end
end

-- spell.action_type == "Magic" ensures that job ability gear survives into midcast, as otherwise they won't work.
function midcast(spell)
    -- If we ever use spells on PUP, steal stuff from other jobs.
    local matched = false

    -- If the spell name EXACTLY matches.
    if not matched and sets.midcast[spell.name] then
        equip_set_and_weapon(sets.midcast[spell.name])
        matched = true
    end

    -- If the spell skill has a relevant set
    if not matched and sets.midcast[spell.skill] then
        equip_set_and_weapon(sets.midcast[spell.skill])
        matched = true
    end

    if not matched and spell.action_type == "Magic" then
        idle()
    end

    -- Missing weather and day overlays (unsure if necessary)
end

function aftercast(spell)
    idle()
end

function status_change(new, old)
    idle()
end

function sub_job_change(new,old)
    update_lockstyle()
    update_macro_book()
end

-- If I want to stop enabling when I don't need to, I could do a "last_mode" variable

function self_command(command)
    -- Lowercase and split
    local commandArgs = T(command:lower():split(" "))
    local main_command = commandArgs[1]
    local sub_command = commandArgs[2]

    if main_command == "meleemode" then
        melee_mode:cycle()
        add_to_chat(123, string.format("Melee mode set to %s", melee_mode.current))

        if melee_mode == "TP" then
            idle()
            send_command("gs disable main;gs disable sub;gs disable range")
        else
            send_command("gs enable main;gs enable sub;gs enable range")
            idle()
        end

    elseif main_command == "weaponmode" then
        weapon_mode:cycle()
        add_to_chat(123, string.format("Weapon mode set to %s", weapon_mode.current))
        idle()

    elseif main_command == "idlemode" then
        idle_mode:cycle()
        add_to_chat(123, string.format("Idle mode set to %s", idle_mode.current))
        idle()

    elseif main_command == "togglespeed" then
        toggle_speed = handle_toggle(toggle_speed, "Speed")
        idle()

    elseif main_command == "toggletextbox" then
        text_box:visible(not text_box:visible())

    else
        add_to_chat(123, "Command not recognised.")
    end

    build_info_box()
end

function file_unload(file_name)
    send_command("unbind f1")

    send_command("unbind f5")
    send_command("unbind f6")

    send_command("unbind f9")

    send_command("unbind f12")
end