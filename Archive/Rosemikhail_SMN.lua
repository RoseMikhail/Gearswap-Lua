---@diagnostic disable: lowercase-global, undefined-global
include("Modes.lua")

idle_mode = M{"PDT", "MDT", "Refresh"}

-- Keybinds for toggling modes
send_command("bind f10 gs c toggleidlemode")
send_command("bind f11 gs c toggletextbox")

add_to_chat(123, "F10: Idle Mode | F11: Toggle Info Box")

-- Info box setup for displaying current modes
default_settings = {
    bg = { alpha = 100 },
    pos = { x = -210, y = 21 },
    flags = { draggable = false, right = true },
    text = { font = "Arial", size = 13 },
}
text_box = texts.new(default_settings)
text_box:text("Idle Mode: " .. idle_mode.current)
text_box:visible(true)

blood_pacts = {
    physical = S{
        'Hysteric Assault','Punch','Rock Throw','Barracuda Dive','Claw','Axe Kick','Shock Strike','Camisado','Regal Scratch','Poison Nails','Moonlit Charge','Crescent Fang','Rock Buster','Tail Whip','Double Punch','Megalith Throw','Double Slap','Eclipse Bite','Mountain Buster','Spinning Dive','Predator Claws','Rush','Chaotic Strike','Crag Throw','Volt Strike', 'Wind Shear'
    },
    hybrid = S{
        'Katabatic Blades','Burning Strike','Flaming Crush', 'Sonic Buffet'
    },
    magical = S{
        'Zantetsuken','Tornado II','Inferno','Earthen Fury','Tidal Wave','Aerial Blast','Diamond Dust','Judgment Bolt','Searing Light','Howling Moon','Ruinous Omen','Fire II','Stone II','Water II','Aero II','Blizzard II','Thunder II','Thunderspark','Somnolence','Meteorite','Fire IV','Stone IV','Water IV','Aero IV','Blizzard IV','Thunder IV','Nether Blast','Meteor Strike','Geocrush','Grand Fall','Wind Blade','Heavenly Strike','Thunderstorm','Level ? Holy','Holy Mist','Lunar Bay','Night Terror','Conflag Strike'
    },
    enfeebling = S{
        'Bitter Elegy','Lunatic Voice','Lunar Cry','Mewing Lullaby','Nightmare','Lunar Roar','Slowga','Ultimate Terror','Sleepga','Eerie Eye','Tidal Roar','Diamond Storm','Shock Squall','Pavor Nocturnus'
    },
    healing = S{
        'Perfect Defense','Chinook','Wind’s Blessing','Shining Ruby','Frost Armor','Rolling Thunder','Crimson Howl','Lightning Armor','Ecliptic Growl','Hastega','Noctoshield','Ecliptic Howl','Dream Shroud','Earthen Armor','Fleet Wind','Inferno Howl','Soothing Ruby','Heavenward Howl','Soothing Current','Hastega II','Crystal Blessing', 'Healing Ruby','Raise II','Aerial Armor','Reraise II','Whispering Wind','Glittering Ruby','Earthen Ward','Spring Water','Healing Ruby II'
    }

    -- TODO: At some point, split healing into healing and buffs - the logic for this and the sets will also need to be split. Or, if you don't care right now, just leave it as is.
}

avatars = S{"Carbuncle", "Cait Sith", "Diabolos", "Fenrir", "Garuda", "Ifrit", "Leviathan", "Ramuh", "Shiva", "Siren", "Titan"} -- Does not include Alexander, Odin or Atomos
spirits = S{"Air Spirit", "Dark Spirit", "Earth Spirit", "Fire Spirit", "Ice Spirit", "Light Spirit", "Thunder Spirit", "Water Spirit"}

-- Define all gearsets
function get_sets()
    sets.idle = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    sets.ja = {}
    sets.ws = {}

    ----------------------------------------------------------------
    -- IDLE
    ----------------------------------------------------------------

    -- Idle sets for downtime behavior
    sets.idle["PDT"] = { -- Physical defense
        main={ name="Gridarvor", augments={'Pet: Accuracy+70','Pet: Attack+70','Pet: "Dbl. Atk."+15',}},
        sub="Oneiros Grip",
        ammo="Sancus Sachet",
        head="Beckoner's Horn +1",
        body="Con. Doublet +1",
        hands="Con. Bracers +1",
        legs="Assid. Pants +1",
        feet={ name="Apogee Pumps", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        neck="Caller's Pendant",
        waist="Lucidity Sash",
        left_ear={ name="Moonshade Earring", augments={'MP+25','Latent effect: "Refresh"+1',}},
        right_ear="Evans Earring",
        left_ring="Evoker's Ring",
        right_ring="Woltaris Ring",
        back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Fast Cast"+3',}},
    }

    sets.idle["MDT"] = set_combine(sets.idle["PDT"], { -- If you have any magic-specific DT gear, put it here. This pulls from the normal PDT set, so you don't need to redefine everything else.
        -- Stuff like Warder's Charm +1
    })
    
    sets.idle["Refresh"] = set_combine(sets.idle["PDT"], { -- Similar story to MDT, but for refresh. I don't know if Summoner cares about refresh. This is one of the few functions you CAN delete, but make sure you also remove it from line #5 of this file if you do.
        -- Anything with refresh on it bbg
    })

    sets.idle.pet = set_combine(sets.idle["PDT"], { -- Honestly dude I don't know but here you go, a pet idle if you need it. Do not delete this because it is in the logic in the idle function.
        -- This is combined with PDT, so you only really need to add any differences. You can just fill the entire set anyway if you want.
    })

    -- Someday, you may want to have a heavier Pet DT set, or maybe a Pet Fervor set. I don't really know how to handle this though - keep in mind that logic will need to be written to handle this if you add these, otherwise the sets won't even be acknowleged.
    -- Missing an idle.engaged set, but you're a caster, so I really don't expect you to be hitting the guy with your stick unless you're using trusts. Not necessary.

    ----------------------------------------------------------------
    -- PRECAST
    ----------------------------------------------------------------

    -- Fast Cast set for spell precast
    sets.precast.fast_cast = {
        -- Shit like Loquacious Earring and the like. This is for non-blood pact spells.
    }

    -- Summoning set when calling an avatar
    --[[sets.precast.summoning = set_combine(sets.precast.fast_cast, {
        -- This pulls from the normal fast_cast set, so you can just fill this with the differences if you want. Alternatively, you can fill it fully anyway.
        -- This is just for summoning your avatars.
    })]]--

    -- Set for before a Blood Pact is cast
    sets.precast.bp = {
        main={ name="Espiritus", augments={'Enmity-6','Pet: "Mag.Atk.Bns."+30','Pet: Damage taken -4%',}},
        sub="Oneiros Grip",
        ammo="Sancus Sachet",
        head="Beckoner's Horn +1",
        body="Con. Doublet +1",
        hands="Con. Bracers +1",
        legs="Assid. Pants +1",
        feet={ name="Apogee Pumps", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        neck="Caller's Pendant",
        waist="Lucidity Sash",
        left_ear={ name="Moonshade Earring", augments={'MP+25','Latent effect: "Refresh"+1',}},
        right_ear="Evans Earring",
        left_ring="Evoker's Ring",
        right_ring="Woltaris Ring",
        back={ name="Conveyance Cape", augments={'Summoning magic skill +4','Pet: Enmity+7','Blood Pact ab. del. II -1',}},
    }

    ----------------------------------------------------------------
    -- BLOOD PACTS
    ----------------------------------------------------------------

    sets.midcast.bp_physical = { -- Melee-based Blood Pacts
        main={ name="Gridarvor", augments={'Pet: Accuracy+70','Pet: Attack+70','Pet: "Dbl. Atk."+15',}},
        sub="Elan Strap",
        ammo="Sancus Sachet",
        head={ name="Apogee Crown", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        body="Con. Doublet +1",
        hands={ name="Merlinic Dastanas", augments={'Pet: Accuracy+24 Pet: Rng. Acc.+24','Blood Pact Dmg.+6','Pet: Mag. Acc.+15','Pet: "Mag.Atk.Bns."+12',}},
        legs={ name="Apogee Slacks", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        feet={ name="Apogee Pumps", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        neck="Summoner's Collar",
        waist="Klouskap Sash",
        left_ear="Gelos Earring",
        right_ear="Evans Earring",
        left_ring="Varar Ring",
        right_ring="Varar Ring",
        back={ name="Campestres's Cape", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: Attack+10 Pet: Rng.Atk.+10','"Fast Cast"+3',}},
    }

    sets.midcast.bp_hybrid = { -- Mixed physical/magic effects
        main="Chatoyant Staff",
        sub="Oneiros Grip",
        ammo="Sancus Sachet",
        head={ name="Apogee Crown", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        body="Con. Doublet +1",
        hands={ name="Merlinic Dastanas", augments={'Pet: Accuracy+24 Pet: Rng. Acc.+24','Blood Pact Dmg.+6','Pet: Mag. Acc.+15','Pet: "Mag.Atk.Bns."+12',}},
        legs={ name="Apogee Slacks", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        feet={ name="Apogee Pumps", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        neck="Summoner's Collar",
        waist="Klouskap Sash",
        left_ear="Gelos Earring",
        right_ear="Evans Earring",
        left_ring="Varar Ring",
        right_ring="Varar Ring",
        back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Pet: Magic Damage+3',}},
    }

    sets.midcast.bp_magical = { -- Magic-based Blood Pacts
        main="Chatoyant Staff",
        sub="Elan Strap",
        ammo="Sancus Sachet",
        head={ name="Apogee Crown", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        body="Con. Doublet +1",
        hands={ name="Merlinic Dastanas", augments={'Pet: Accuracy+24 Pet: Rng. Acc.+24','Blood Pact Dmg.+6','Pet: Mag. Acc.+15','Pet: "Mag.Atk.Bns."+12',}},
        legs="Assid. Pants +1",
        feet={ name="Apogee Pumps", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        neck="Eidolon Pendant +1",
        waist="Caller's Sash",
        left_ear="Gelos Earring",
        right_ear="Evans Earring",
        left_ring="Varar Ring",
        right_ring="Varar Ring",
        back={ name="Campestres's Cape", augments={'Pet: M.Acc.+20 Pet: M.Dmg.+20','Pet: Magic Damage+3',}},
    }

    sets.midcast.bp_enfeebling = { -- Enfeebling Blood Pacts
         -- This currently contains what was wardbp.lua - it likely needs some tweaking.
        main={ name="Espiritus", augments={'Enmity-6','Pet: "Mag.Atk.Bns."+30','Pet: Damage taken -4%',}},
        sub="Vox Grip",
        ammo="Sancus Sachet",
        head="Beckoner's Horn +1",
        body="Con. Doublet +1",
        hands="Inyan. Dastanas +1",
        legs="Assid. Pants +1",
        feet={ name="Apogee Pumps", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        neck="Caller's Pendant",
        waist="Lucidity Sash",
        left_ear="Lodurr Earring",
        right_ear="Evans Earring",
        left_ring="Evoker's Ring",
        right_ring="Fervor Ring",
        back={ name="Conveyance Cape", augments={'Summoning magic skill +4','Pet: Enmity+7','Blood Pact ab. del. II -1',}},
    }

    sets.midcast.bp_healing = { -- Healing/Enhancing Blood Pacts
        -- This currently contains what was wardbp.lua - it likely needs some tweaking.
        main={ name="Espiritus", augments={'Enmity-6','Pet: "Mag.Atk.Bns."+30','Pet: Damage taken -4%',}},
        sub="Vox Grip",
        ammo="Sancus Sachet",
        head="Beckoner's Horn +1",
        body="Con. Doublet +1",
        hands="Inyan. Dastanas +1",
        legs="Assid. Pants +1",
        feet={ name="Apogee Pumps", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        neck="Caller's Pendant",
        waist="Lucidity Sash",
        left_ear="Lodurr Earring",
        right_ear="Evans Earring",
        left_ring="Evoker's Ring",
        right_ring="Fervor Ring",
        back={ name="Conveyance Cape", augments={'Summoning magic skill +4','Pet: Enmity+7','Blood Pact ab. del. II -1',}},
    }

    ----------------------------------------------------------------
    -- MIDCAST
    ----------------------------------------------------------------
    
    sets.midcast.casting = { -- General casting of whatever spells
        -- This is your stuff with magic attack bonus or magic burst on it - for casting stuff like Fire V and such - probably depends on your subjob
    }

    sets.midcast.cure = {
        -- You can figure out what to put here lol
    }

    sets.midcast.enhancing = {
        -- Enchancing specific spells, maybe if you're sub red mage
    }

    sets.midcast.stoneskin = {
        -- Specifically stoneskin; don't ask me why everyone has a separate set for this but they do
    }

    ----------------------------------------------------------------
    -- JA
    ----------------------------------------------------------------
    
    sets.ja["Elemental Siphon"] = {
        main="Chatoyant Staff",
        sub="Vox Grip",
        ammo="Esper Stone +1",
        head="Con. Horn +1",
        body="Con. Doublet +1",
        hands="Con. Bracers +1",
        legs="Assid. Pants +1",
        feet={ name="Apogee Pumps", augments={'Pet: Attack+20','Pet: "Mag.Atk.Bns."+20','Blood Pact Dmg.+7',}},
        neck="Caller's Pendant",
        waist="Lucidity Sash",
        left_ear="Lodurr Earring",
        right_ear="Evans Earring",
        left_ring="Evoker's Ring",
        right_ring="Fervor Ring",
        back={ name="Conveyance Cape", augments={'Summoning magic skill +4','Pet: Enmity+7','Blood Pact ab. del. II -1',}},
    }

    sets.ja["Name of literally any other job action"] = { -- Follow this format, and the code will recognise the set as long as the name is correct

    }
    
    ----------------------------------------------------------------
    -- WS
    ----------------------------------------------------------------
    
    -- You probably aren't using any weaponskills yet, but it's handy to have eh?
    sets.ws["Name of weaponskill"] = { -- Follow this format, and the code will recognise the set as long as the name is correct
        
    }

end

-- Precast is triggered before spell cast begins
function precast(spell)
    if pet_midaction() then
        return
    end

    -- If summoning an avatar
    --[[if spell.type == "SummonerPact" then
        equip(sets.precast.summoning)
        return
    end]]--

    -- If casting a Blood Pact
    if spell.type == "BloodPactRage" or spell.type == "BloodPactWard" then
        equip(sets.precast.bp)
        return
    end

    if sets.ja[spell.name] then                 -- Job Abilities
        equip(sets.ja[spell.name])
    elseif sets.ws[spell.name] then             -- Weapon Skills
        equip(sets.ws[spell.name])
    elseif spell.type ~= "JobAbility" then      -- Avoid unhandled Job Abilities
        if spell.action_type == "Magic" then    -- Avoid unhandled Weapon Skills
            if sets.precast[spell.name] then    -- Specific spells
                equip(sets.precast[spell.name])
            else
                -- General purpose
                equip(sets.precast.fast_cast)
            end
        end
    end
end

-- Midcast is triggered during spell execution
function midcast(spell)
    -- If our pet is doing something, prevents us swapping equipment too early
    if pet_midaction() then
        return
    end
    
    if spell.type == 'WhiteMagic' or spell.type == 'BlackMagic' then
        if spell.name == 'Stoneskin' then
            equip(sets.midcast.stoneskin)
        elseif spell.name:match('Cure') or spell.name:match('Cura') then
            equip(sets.midcast.cure)
        elseif spell.skill == 'Enhancing Magic' then
            equip(sets.midcast.enhancing)
        else
            equip(sets.midcast.casting) -- Catchall.
            -- If specific sets need to be switched to for particular spells, then do consult ME Rosa Miguel
        end
    end
end

function pet_midcast(spell)
    if spell.type == "BloodPactRage" or spell.type == "BloodPactWard" then
        if blood_pacts.physical:contains(spell.name) then
            equip(sets.midcast.bp_physical)
        elseif blood_pacts.hybrid:contains(spell.name) then
            equip(sets.midcast.bp_hybrid)
        elseif blood_pacts.magical:contains(spell.name) then
            equip(sets.midcast.bp_magical)
        elseif blood_pacts.enfeebling:contains(spell.name) then
            equip(sets.midcast.bp_enfeebling)
        elseif blood_pacts.healing:contains(spell.name) then
            equip(sets.midcast.bp_healing)
        end
    end
end


-- Aftercast applies once casting finishes
function aftercast(spell)
    if pet_midaction() then
        return
    end

    -- Gearswap will not immediately register the pet's summoning, so we skip this and wait for pet_change to handle the idle swap.
    if avatars:contains(spell.name) or spirits:contains(spell.name) then
        return
    end

    -- Gearswap will not immediately register the pet's release, so we switch directly to our current idle mode.
    if spell.name == "Release" then
        if sets.idle[idle_mode.current] then
            equip(sets.idle[idle_mode.current])
        else
            add_to_chat(123, "Invalid idle set: " .. idle_mode.current)
        end
        return
    end

    -- If casting a Blood Pact, skip switching back to idle here, as this will occur during the pet_aftercast... probably.
    if spell.type == "BloodPactRage" or spell.type == "BloodPactWard" then
        return
    end

    idle()
end

function pet_aftercast(spell)
    idle()
end

-- Handles status change (e.g., from Idle to Engaged)
function status_change(new, old)
    idle()
end

function pet_change(pet,gain)
    -- We switch to the pet idle set here on the initial summon instead of via the aftercast, as gearswap does not immediately register the summoning.
    if gain == true then
        equip(sets.idle.pet)

    -- If the pet disappears for any reason, then switch back to the regular idle ONLY if the Summoner is not currently doing something.
    elseif gain == false then
        if not midaction() and not pet_midaction() then
            -- Use current idle mode, or fall back to PDT
            if sets.idle[idle_mode.current] then
                equip(sets.idle[idle_mode.current])
            else
                equip(sets.idle["PDT"])
            end
        end
    end
end

-- Determines what gear to equip when standing idle
function idle()
    if pet.isvalid then
        equip(sets.idle.pet)
        return
    end

    -- Use current idle mode, or fall back to PDT
    if sets.idle[idle_mode.current] then
        equip(sets.idle[idle_mode.current])
    else
        equip(sets.idle["PDT"])
    end
end

-- Handles manual commands via keybinds
function self_command(command)
    local cmd = command:lower()

    if cmd == "toggleidlemode" then
        idle_mode:cycle()
        add_to_chat(123, "Idle Mode: " .. idle_mode.current)
        idle()

    elseif cmd == "toggletextbox" then
        text_box:visible(not text_box:visible())
    end

    -- Update textbox display
    text_box:text("Idle Mode: " .. idle_mode.current)
end

-- Unbind keys on file unload
function file_unload()
    send_command("unbind f10")
    send_command("unbind f11")
end
