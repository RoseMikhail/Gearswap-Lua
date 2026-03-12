---@diagnostic disable: lowercase-global, undefined-global
include("Modes.lua")
----------------------------------------------------------------
-- Checks to add
----------------------------------------------------------------
--[[

//// FUNCTIONALITY /////
-- Create JA sets and checks
    - AF gear
    - Relic gear (though I might need to comment it out to start with)
        - head: maybe consider the focalization thing, but I'm not sure if I care
    - Empyrean gear
        - Ebullience/Rapture check
            - If either buff is active, equip arbatel bonnet (empyrean head) when casting either Healing Magic or Black Magic
        - Perpetuance check
            - If perpetuance buff is active, equip empyrean hands when casting White Magic Enhancing Magic
        - Technically there could be a check for the empyrean +3 legs for penury/parsimony, but I'm pretty sure I'm always going to be nuking in them anyway
        - Same shit for the empyrean feet + klimaform, but yeah, I'll be wearing these anyway...
    

-- for other jobs too but I think chatoyant doesn't work on both day and weather

//// SETS + ASSOCIATED CHECKS /////
UPDATE THESE SETS BUT MOSTLY JUST FOLLOW WIKI AND PAY ATTENTION TO THE AF/RELIC/EMPYREAN STATS AND SLOT APPROPRIATELY
- Cursna set https://www.bg-wiki.com/ffxi/Community_Scholar_Guide#Cursna
- Regen set https://www.bg-wiki.com/ffxi/Community_Scholar_Guide#Regen 
- Stoneskin set https://www.bg-wiki.com/ffxi/Community_Scholar_Guide#Enhancing
- Aquaveil set
- Sublimation set
- Kaustra
- Update Myrkr
- Combine the DT sets; there's no reason not to. Do this for the other jobs too.
-- Do cure DT set, kaykaus came come later
-- Do regen duration set, potency toggle can come later
-- Compare against any other sets in the wiki guide



//// STRETCH GOALS /////
- Chat message or something to say that Sublimation has finished charging - can extend to blm
- Doomed set https://www.bg-wiki.com/ffxi/Community_Scholar_Guide#Misc_Sets - extend to other jobs
- Stun midcast recast (yeah maybe) + apply to other jobs
- Regen potency vs regen toggle
- Cure DT vs potency toggle
- When more sources of fastcast have been obtained, consider creating a Grimoire fastcast set
    - In other words, I need to be able to get 80% regular fastcast in all slots minus the head and feet for this to become viable as a set
    - Only for when we're casting white or dark magic under the correct art/addendum
    - Doesn't work when Accession, Alacrity, Celerity or Manifestation would affect the spell
- Aspir/Drain magic burst set. Apply to BLM/GEO as well.
- More idle modes- normal one, full DT/meva, etc.
-- maybe modify "overlay" to be "buff" and change all gear check equips in midcast/etc to singleslot gearsets
-- Multiple immanence modes? currently I have haste/fc/dt, but consider a subtle blow/haste/fc set and then a separate one for dt, maybe also consider using skilchain+ damage
-- I could technically have dark and light versions of all of the healing stuff, due to the academic pants, but this seems not very worth it
]]
----------------------------------------------------------------
-- NOTES
----------------------------------------------------------------
--[[
Potential enhancements:
- Save certain toggles and sets between reloads
]]
----------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------

-- Modes and toggles
nuking_mode = M{"Free Nuke", "Burst", "Occult Acumen", "Vagary Burst"}
idle_mode = M{"PDT", "MDT", "Refresh"}
weapon_mode = M{"Staff", "Wizard", "Maxentius"}

toggle_speed = "Off"
toggle_tp = "Off" -- This will disable weapon swapping as well

-- Command helpers
nuking_mode_pairs = {
    freenuke = "Free Nuke",
    burst = "Burst",
    occultacumen = "Occult Acumen",
    vagaryburst = "Vagary Burst"
}

-- Midcast helpers
match_list = S{"Cure", "Aspir", "Drain", "Regen"}
helix_spells = S{"Geohelix", "Hydrohelix", "Anemohelix", "Pyrohelix", "Cryohelix", "Ionohelix", "Noctohelix", "Luminohelix", "Geohelix II", "Hydrohelix II", "Anemohelix II", "Pyrohelix II", "Cryohelix II", "Ionohelix II", "Noctohelix II", "Luminohelix II",}

-- Bindings
send_command("bind f1 gs c nukemode freenuke")
send_command("bind f2 gs c nukemode burst")
send_command("bind f3 gs c nukemode occultacumen")
send_command("bind f4 gs c nukemode vagaryburst")

send_command("bind f5 gs c weaponmode")
send_command("bind f6 gs c idlemode")
send_command("bind f7 gs c toggletp")

send_command("bind f9 gs c togglespeed")
send_command("bind f12 gs c toggletextbox")

-- Help Text
add_to_chat(123, "F1-F4: Switch nuking mode")
add_to_chat(123, "F5: Switch weapon set, F6: Cycle idle mode")
add_to_chat(123, "F7: Toggle TP lock")
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
        "Mode: %s | Wep: %s | Idle: %s | TP Lock: %s | Speed: %s",
        nuking_mode.current,
        weapon_mode.current,
        idle_mode.current,
        format_toggle(toggle_tp),
        format_toggle(toggle_speed)
    )

    text_box:text(output)
end

build_info_box()

----------------------------------------------------------------
-- MISC INIT/COMMANDS
----------------------------------------------------------------

-- Lockstyle
send_command("wait 3;input /lockstyleset 9") -- SCH Empy

function update_macro_book()
    -- SCH/WHM macro book
    send_command("input /macro book 3;input /macro set 1")
end

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
        head="Acad. Mortar. +3",
        body="Acad. Gown +3",
        hands="Acad. Bracers +3",
        legs="Acad. Pants +3",
        feet="Acad. Loafers +3",
    }

    jse.relic = {
        head="Argute M.board +2",
        body="Argute Gown +2",
        hands="Argute Bracers +2",
        legs="Argute Pants +2",
        feet="Argute Loafers +2",
    }

    jse.empyrean = {
        head="Arbatel Bonnet +3",
        body="Arbatel Gown +3",
        hands="Arbatel Bracers +3",
        legs="Arbatel Pants +2",
        feet="Arbatel Loafers +3",
    }

    jse.capes = {
        nuking_idle={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
        occult_acumen={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Store TP"+10',}},
        --enfeebling="", unnecessary?
        --tp="", Melee TP: DEX +20, Acc +30, Atk +20, Store TP +10 ... er another 10 dex i think
        --wsd="", Vidohunir/WS: INT +30, Macc/Mdmg +20, Weapon Skill Damage +10%
        --curing="" MND+20, Mag. Evasion +10, Eva.+20/Mag.Eva+20, Enmity -10, Damage taken -5%
        -- Maybe high mp cape?
    }

    ----------------------------------------------------------------
    -- WEAPON SETS
    ----------------------------------------------------------------
    
    weapon_sets = {
        ["Staff"] = {
            main={ name="Marin Staff +1", augments={'Path: A',}},
            sub="Enki Strap",
        },
        ["Wizard"] = {
            main="Wizard's Rod",
            sub="Ammurapi Shield",
        },
        ["Maxentius"] = {
            main="Maxentius",
            sub="Ammurapi Shield",
        },
    }

    -- Consider Malignance pole/Malevolence for later.

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
    -- PRECAST
    ----------------------------------------------------------------

    -- When I can overcap FC considerably more, consider looking into setting up grimoire casting.
    sets.precast.fast_cast = {                                                                                                          -- OVERALL 81% FC, 2% Occ
        ammo="Impatiens",                                                                                                               -- 2% Occ
        head={ name="Merlinic Hood", augments={'"Fast Cast"+6','"Mag.Atk.Bns."+8',}},                                                   -- 14% FC
        body={ name="Merlinic Jubbah", augments={'Mag. Acc.+2','"Fast Cast"+7','INT+9','"Mag.Atk.Bns."+7',}},                           -- 13% FC
        hands={ name="Merlinic Dastanas", augments={'Mag. Acc.+8 "Mag.Atk.Bns."+8','"Fast Cast"+7','MND+5','Mag. Acc.+11',}},           -- 7% FC
        legs="Orvail Pants +1",                                                                                                         -- 5% FC
        feet={ name="Merlinic Crackows", augments={'"Fast Cast"+6','CHR+2','Mag. Acc.+8','"Mag.Atk.Bns."+11',}},                        -- 11% FC
        neck="Voltsurge Torque",                                                                                                        -- 4% FC
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},                                                                     -- 5% FC
        left_ear="Malignance Earring",                                                                                                  -- 4% FC
        right_ear="Loquacious Earring",                                                                                                 -- 2% FC
        left_ring="Kishar Ring",                                                                                                        -- 4% FC
        right_ring="Prolix Ring",                                                                                                       -- 2% FC
        back="Fi Follet Cape +1",                                                                                                       -- 10% FC
    }

    sets.precast["Impact"] = set_combine(sets.precast.fast_cast, {
        head=empty,
        body="Crepuscular Cloak",
    })

    sets.precast["Dispelga"] = set_combine(sets.precast.fast_cast, {
        main="Daybreak",
        sub="Genmei Shield",
    })

    ----------------------------------------------------------------
    -- NUKE MIDCAST MODES
    ----------------------------------------------------------------
    
    -- TODO: SIM with what I have + recheck each individual piece
    -- I suspect lots of Empyrean gear + Mujin Band

    sets.midcast["Free Nuke"] = {
        ammo="Sroda Tathlum",
        head=jse.empyrean.head,
        body=jse.empyrean.body,
        hands=jse.empyrean.hands,
        legs=jse.empyrean.legs,
        feet=jse.empyrean.feet,
        neck="Saevus Pendant +1",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear="Barkaro. Earring",
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back=jse.capes.nuking_idle
    }

    -- Probably want Argute Stole +1 for 7% MB
    sets.midcast["Burst"] = {                                                                                           -- 31% MB, 15% MB II
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head=jse.empyrean.head,
        body=jse.empyrean.body,
        --hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},                    -- 6% MB II
        hands=jse.empyrean.hands,                                                                                       -- 10% MB
        legs=jse.empyrean.legs,
        feet=jse.empyrean.feet,                                                                                         -- 4% MB II
        neck="Mizukage-no-Kubikazari",                                                                                  -- 10% MB
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear="Barkaro. Earring",
        left_ring="Locus Ring",                                                                                         -- 5% MB
        right_ring="Mujin Band",                                                                                        -- 5% MB II
        back=jse.capes.nuking_idle,
    }

    sets.midcast["Occult Acumen"] = set_combine(sets.midcast["Free Nuke"], {
        ammo="Seraphic Ampulla",
        head="Mallquis Chapeau +2",
        --body=
        --hands=
        legs= "Perdition Slops",
        feet="Battlecast Gaiters",
        --neck=,
        waist="Oneiros Rope",
        left_ear="Steelflash Earring",
        right_ear="Bladeborn Earring",
        left_ring="Petrov Ring",
        right_ring="Lehko's Ring",
        back=jse.capes.occult_acumen,
    })

    -- Tweak as necessary. I'm not exactly sure what this set should look like yet.
    sets.midcast["Vagary Burst"] = set_combine(sets.midcast["Free Nuke"], {
        main=empty,
        sub=empty,
        --ammo=empty,
        --head=empty,
        --body=empty,
        --hands=empty,
        --legs=empty,
        --feet=empty,
        --neck=empty,
        --waist=empty,
        --left_ear=empty,
        --right_ear=empty,
        --left_ring=empty,
        --right_ring=empty,
        --back=empty,
    })

    sets.midcast.helix = {} -- Leave this empty.

    sets.midcast.helix["Free Nuke"] = set_combine(sets.midcast["Free Nuke"], {
        --ammo=,
        --head=,
        --body=,
        --hands=,
        --legs=,
        --feet=,
        --neck=,
        --waist=,
        --left_ear=,
        --right_ear=,
        --left_ring=,
        --right_ring=,
        --back=,
    })

    sets.midcast.helix["Burst"] = set_combine(sets.midcast["Burst"], {
        --ammo=,
        --head=,
        --body=,
        --hands=,
        --legs=,
        --feet=,
        --neck=,
        --waist=,
        --left_ear=,
        --right_ear=,
        --left_ring=,
        --right_ring=,
        --back=,
    })

    ----------------------------------------------------------------
    -- ENFEEBLING MIDCAST
    ----------------------------------------------------------------

    sets.midcast.enfeebling_dark = {
        ammo="Pemphredo Tathlum",
        head=jse.AF.head,
        body=jse.AF.body,
        hands=jse.empyrean.hands,
        legs=jse.empyrean.legs,
        feet=jse.empyrean.feet,
        neck="Incanter's Torque",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear={ name="Arbatel Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+7',}},
        left_ring="Kishar Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.midcast.enfeebling_light = {
        ammo="Pemphredo Tathlum",
        head=empty,
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands=jse.empyrean.hands,
        legs=jse.empyrean.legs,
        feet=jse.empyrean.feet,
        neck="Incanter's Torque",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear={ name="Arbatel Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+7',}},
        left_ring="Kishar Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.midcast["Dispelga"] = set_combine(sets.midcast["Enfeebling Magic"], {
        main="Daybreak",
        sub="Ammurapi Shield",
    })
    
    -- Impact likes more elemental magic skill
    -- TODO: This wants Artifact hands
    sets.midcast["Impact"] = {
        ammo="Pemphredo Tathlum",
        head=empty,
        body="Crepuscular Cloak",
        hands=jse.empyrean.hands,
        legs=jse.empyrean.legs,
        feet=jse.empyrean.feet,
        neck="Incanter's Torque",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear="Ilmr Earring", -- Replace with Regal Earring (and move Ilmr to Malignance's spot)
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    ----------------------------------------------------------------
    -- ENHANCING MIDCAST
    ----------------------------------------------------------------

    -- TODO: Improve Telchine to 10% if possible
    -- TODO: Relic body +2 (8%) then +3 (12%)
    -- TOOD: Musa someday for 20% BUT LMAO
    -- TODO: Skill items: Mimir Earring, Fi Folet Cape +1, Andoaa Earring (+24 in total). Relic body will be better +3 for duration (+12%) and enhancing skill (+19). WORSE duration at +2. Stikini +1 x2...
    -- Increase enhancing skill to 500. Currently 479. Note that some spells are better at 500, so maybe accept 2% worse duration and just use relic body at +2.

    -- Probably accept slightly less duration for the relic body's higher enhancing skill
    -- Check my passive skill before doing anything here. Job mastery!
    sets.midcast["Enhancing Magic"] = {                                                                                             -- +71% duration
        main={ name="Gada", augments={'Enh. Mag. eff. dur. +6',}},                                                                  -- +6% duration
        sub="Ammurapi Shield",                                                                                                      -- +10% duration
        range=empty,
        ammo="Pemphredo Tathlum",
        head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +8',}},                                                          -- +8% duration
        body={ name="Telchine Chas.", augments={'Pet: "Regen"+3','Enh. Mag. eff. dur. +10',}},                                      -- +10% duration
        hands={ name="Telchine Gloves", augments={'Pet: "Regen"+3','Enh. Mag. eff. dur. +9',}},                                     -- +9% duratiom. This should be replaced by empy hands during Perpetuance
        legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +9',}},                                                      -- +9% duration
        feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +9',}},                                                     -- +9% duration
        neck="Incanter's Torque",
        waist="Embla Sash",                                                                                                         -- +10% duration
        left_ear="Mendi. Earring", -- Probably this one to replace with Andoaa
        right_ear="Gwati Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back="Fi Follet Cape +1",
    }

    -- Do not replace telchine body for duration. Unless ofc you're using Relic +3 I think. Regen duration +12!!
    -- Fill other slots with Conserve MP.

    -- Technically the hands only need to be on for Perpetuance, could use telchine hands otherwise
    -- TODO: check for perpetuance and set these hands back to telchine
    sets.midcast["Regen"] = set_combine(sets.midcast["Enhancing Magic"], {
        main="Bolelabunga",                                                                                                         -- +10% potency
        head=jse.empyrean.head,                                                                                                     -- +20% potency
        body={ name="Telchine Chas.", augments={'Pet: "Regen"+3','Enh. Mag. eff. dur. +10',}},                                      -- +10% duration, +12 duration
        hands=jse.empyrean.hands,                                                                                                   -- Perpetuance +60% duration
        back=jse.capes.nuking_idle,                                                                                                 -- +15 duration
    })

    sets.midcast.barspell = set_combine(sets.midcast["Enhancing Magic"], {
        --ammo=,
        --head=,
        --body=,
        --hands=,
        --legs=,
        --feet=,
        --neck=,
        --waist=,
        --left_ear=,
        --right_ear=,
        --left_ring=,
        --right_ring=,
        back="Fi Follet Cape +1",
    })

    ----------------------------------------------------------------
    -- CURING MIDCAST
    ----------------------------------------------------------------

    -- TODO: Just turn this into a DT cure set. Swap out the healing magic skill for conserve mp and the like. See the set on the scholar wiki and see what I can do.
    -- TODO: Full conserve toggle can come later with kaykaus etc...
    -- AF legs might be good with 15% cure potency + skill

    sets.midcast["Cure"] = set_combine(sets.midcast["Free Nuke"], {                                                                 -- Overall +50% Cure Potency, +33% Conserve MP, -10% PDT, 28% DT (38% PDT, 28% MDT)
        main="Daybreak",                                                                                                            -- 30% Cure Potency
        sub="Genmei Shield",                                                                                                        -- -10% PDT
        ammo="Staunch Tathlum",                                                                                                     -- -2% DT
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},      -- +10% Cure Potency, +6% Conserve MP
        body={ name="Vanya Robe", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        hands={ name="Vanya Cuffs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},     -- +6% Conserve MP
        feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},     -- +5% Cure Potency, +6% Conserve MP
        neck="Loricate Torque +1",                                                                                                  -- -6% DT
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},                                                                 -- +15% Conserve MP
        left_ear="Mendi. Earring",                                                                                                  -- +5% Cure Potency
        right_ear="Meili Earring", -- Replace with DT/Conserve MP
        left_ring="Murky Ring",                                                                                                     -- -10% DT
        right_ring="Defending Ring",                                                                                                -- -10% DT
        back={ name="Aurist's Cape +1", augments={'Path: A',}}, -- Fi Folet +1 has conserve mp of +5 ORRRRRRRRRR REPLACE WITH MND/EVA/PDT CAPE
    })

    ----------------------------------------------------------------
    -- OTHER MIDCAST
    ----------------------------------------------------------------

    -- TODO: Maybe go for Merly aspir/drain but also are you trying to wreck my wardrobes?
    -- TODO: AF body is going to be better when in Dark Arts, make exception for this... or maybe just keep AF robe here anyway. I'm usually going to be in Dark Arts for Aspiring, I should imagine.
    sets.midcast["Aspir"] = set_combine(sets.midcast["Free Nuke"], {
        main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}},
        sub="Ammurapi Shield",
        head="Pixie Hairpin +1",
        body="Shango Robe", 
        --hands=
        legs=jse.relic.legs,
        --feet="",
        neck="Erra Pendant",
        waist="Fucho-no-Obi",
        left_ear="Barkaro. Earring",
        --right_ear=
        left_ring="Archon Ring",
        right_ring="Evanescence Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}}, -- TODO: Use bookworm's cape instead
    })

    sets.midcast["Drain"] = sets.midcast["Aspir"]

    ----------------------------------------------------------------
    -- IDLE MODES
    ----------------------------------------------------------------

    -- TODO: At some stage, I would like to replace the Loricate Torque with the Warder's Charm and hopefully have capped PDT and MDT in the same set
    -- Could replace one of the earrings with the Hearty Earring too
    -- Consider also a max DT+evasion set (ws cleaves?)

    -- TODO: Can use Homiliary when my DT is a bit higher, or maybe just rely on Shell to make up the difference in DT
    sets.idle["PDT"] = {                                                                                                                                -- OVERALL -48% DT, -10% PDT, -3% MDT (-58% DT+PDT, -51% DT+MDT), +7-8 refresh
        ammo="Staunch Tathlum",                                                                                                                         -- -2% DT
        head={ name="Merlinic Hood", augments={'DEX+11','Pet: "Store TP"+6','"Refresh"+2','Accuracy+16 Attack+16','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},    -- +2 Refresh
        body=jse.empyrean.body,                                                                                                                         -- +3 Refresh, 13% DT
        hands="Nyame Gauntlets",                                                                                                                        -- 7% DT
        legs="Assid. Pants +1",                                                                                                                         -- +1-2 Refresh
        feet=jse.empyrean.feet,                                                                                                                         -- We're capped on DT so, shrug, some meva
        neck="Loricate Torque +1",                                                                                                                      -- -6% DT
        waist="Fucho-no-Obi",                                                                                                                           -- +1 Refresh
        left_ear="Nehalennia Earring",
        right_ear="Etiolation Earring",                                                                                                                 -- -3% MDT
        left_ring="Murky Ring",                                                                                                                         -- -10% DT
        right_ring="Defending Ring",                                                                                                                    -- -10% DT
        back=jse.capes.nuking_idle                                                                                                                      -- -10% PDT
    }

    sets.idle["MDT"] = set_combine(sets.idle["PDT"], {                                                                                                  -- OVERALL -50% DT, -0% PDT, -3% MDT (-50% DT+PDT, -53% DT+MDT), + refresh
        head=jse.empyrean.head,                                                                                                                         -- -9% DT
        neck="Warder's Charm +1",                                                                                                                       -- Reduction of 6% DT from base set
        back="Tuilha Cape",                                                                                                                             -- Reduction of 10% PDT from base set
    })

    sets.idle["Refresh"] = set_combine(sets.idle["PDT"], {                                                                                              -- OVERALL -43% DT, -10% PDT, -0% MDT (-53% DT+PDT, -43% DT+MDT), +9-10 refresh
        ammo="Homiliary",                                                                                                                               -- +1 Refresh
        head={ name="Merlinic Hood", augments={'DEX+11','Pet: "Store TP"+6','"Refresh"+2','Accuracy+16 Attack+16','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},    -- +2 Refresh
        body=jse.empyrean.body,                                                                                                                         -- +3 Refresh, 12% DT
        hands="Serpentes Cuffs",                                                                                                                        -- -0%      +0.5 Refresh with Serpentes Sabots
        legs="Assid. Pants +1",                                                                                                                         --          1-2 Refresh (realistically 1)
        feet="Serpentes Sabots",                                                                                                                        -- -0%      +0.5 Refresh with Serpentes Cuffs
        neck="Loricate Torque +1",                                                                                                                      -- -6% DT
        waist="Fucho-no-Obi",                                                                                                                           -- -0%      +1 Refresh -- Maybe replace with Shinjutsu-no-Obi someday according to guide
        left_ear="Nehalennia Earring",
        right_ear="Alabaster Earring",                                                                                                                  -- -5% DT
        left_ring="Murky Ring",                                                                                                                         -- -10% DT
        right_ring="Defending Ring",                                                                                                                    -- -10% DT
        back=jse.capes.nuking_idle                                                                                                                      -- -10% PDT
    })

    ----------------------------------------------------------------
    -- MELEE "IDLE"
    ----------------------------------------------------------------
    
    -- This set is trying its best for accuracy but is suffering; it is a work in progress
    -- Nyame RP will help a lot, as will stuff like Chirich
    sets.melee.TP = {
        ammo="Amar Cluster",
        head="Null Masque",
        body=jse.empyrean.body,
        hands=jse.empyrean.hands,
        legs=jse.empyrean.legs,
        feet=jse.empyrean.feet, -- Could instead be Battlecast Gaiters
        neck="Null Loop",
        waist="Null Belt", -- Could instead be Grunfeld
        left_ear="Cessance Earring",
        right_ear="Odnowa Earring +1",
        left_ring="Petrov Ring",
        right_ring="Lehko's Ring",
        back="Null Shawl",
    }

    -- The above set is simmed to work with club/staff, but any dagger TP seems to vastly prefer Haste and Store TP stats + also begs for accuracy

    ----------------------------------------------------------------
    -- JOB ABILITIES 
    ----------------------------------------------------------------

    --[[
    sets.ja["???"] = {
        body="",
    }
    
    ]]

    ----------------------------------------------------------------
    -- WEAPONSKILLS 
    ----------------------------------------------------------------
    
    -- SIM THESE
    
    sets.ws.default = { -- Hybrid DT, generic for physical weaponskills (idk what else to put here)
        ammo="Amar Cluster",
        head="Jhakri Coronal +2",
        body="Nyame Mail",
        hands="Jhakri Cuffs +2",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Null Loop",
        waist="Grunfeld Rope",
        left_ear="Odnowa Earring +1",
        right_ear="Moonshade Earring",
        left_ring="Murky Ring",
        right_ring="Defending Ring",
        back="Alabaster Mantle",
    }

    -- Fill with MAB gear
    sets.ws["Aeolian Edge"] = { -- DEX/INT scaling, Hybrid DT, requires RDM sub
        ammo="Sroda Tathlum",
        head=jse.empyrean.head,
        body=jse.empyrean.body,
        hands=jse.empyrean.hands,
        legs=jse.empyrean.legs,
        feet=jse.empyrean.feet,
        neck="Saevus Pendant +1",
        waist="Eschan Stone",
        left_ear="Moonshade Earring",
        right_ear={ name="Arbatel Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+7',}},
        left_ring="Murky Ring",
        right_ring="Defending Ring",
        back="Alabaster Mantle", -- WSD + PDT Ambu cape will be better.
    }

    sets.ws["Black Halo"] = { -- MND/STR scaling, re-sim this
        ammo="Amar Cluster",
        head=jse.empyrean.head,
        body=jse.empyrean.body,
        hands=jse.empyrean.hands,
        legs=jse.empyrean.legs,
        feet=jse.empyrean.feet,
        neck="Null Loop",
        waist="Null Belt",
        left_ear="Moonshade Earring",
        right_ear={ name="Arbatel Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+7',}},
        left_ring="Murky Ring",
        right_ring="Rufescent Ring",
        back="Alabaster Mantle",
    }

    sets.ws["Realmrazer"] = { -- MND scaling, Hybrid DT, re-sim this
        ammo="Amar Cluster",
        head=jse.empyrean.head,
        body=jse.empyrean.body,
        hands=jse.empyrean.hands,
        legs=jse.empyrean.legs,
        feet=jse.empyrean.feet,
        neck="Null Loop",
        waist="Null Belt",
        left_ear="Moonshade Earring",
        right_ear="Odnowa Earring +1",
        left_ring="Metamor. Ring +1",
        right_ring="Rufescent Ring",
        back="Null Shawl",
    }

    sets.ws["Myrkr"] = { -- No DT
        ammo="Strobilus",
        head={ name="Kaabnax Hat", augments={'HP+30','MP+30','MP+30',}},                                                                -- Want to replace with Amalric Coif +1 augmented
        body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
        hands="Otomi Gloves",
        legs=jse.empyrean.legs,                                                                                                         -- Want to replace with Amalric Slops +1 augmented
        feet={ name="Psycloth Boots", augments={'MP+50','INT+7','"Conserve MP"+6',}},
        neck="Dualism Collar +1",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Nehalennia Earring",
        right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
        left_ring="Mephitas's Ring",
        right_ring="Mephitas's Ring +1",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    --TODO: Black Halo when I unlock it

    ----------------------------------------------------------------
    -- BUFF 
    ----------------------------------------------------------------

    sets.buff.sublimation = {
        head=jse.AF.head,                                                                                                               -- Sublimation +4
        --body=jse.relic.body,                                                                                                            -- Sublimation +2
        waist="Embla Sash",                                                                                                             -- Sublimation +3
    }

    -- TODO: Fill out with Subtle Blow gear as well
    sets.buff.immanence = { -- 10% PDT, 37% DT (47% PDT, 37% MDT), 36% Haste (26 Cap), 40 FC (20% FC haste)
        main=empty,
        sub="Genmei Shield",            -- 10% PDT
        range=empty,
        ammo="Staunch Tathlum",         -- 2% DT
        head="Null Masque",             -- 10% DT, 10% Haste
        body="Shango Robe",             -- 3% FC, 3% Haste
        hands="Acad. Bracers +3",       -- 9% FC, 3% Haste
        legs="Acad. Pants +3",          -- 5% Haste
        feet="Acad. Loafers +3",        -- 12% Grimoire FC
        neck="Voltsurge Torque",        -- 4% FC
        waist="Cornelia's Belt",        -- 10% Haste
        left_ear="Alabaster Earring",   -- 5% DT, 5% Haste
        right_ear="Loquac. Earring",    -- 2% FC
        left_ring="Murky Ring",         -- 10% DT
        right_ring="Defending Ring",    -- 10% DT
        back="Fi Follet Cape +1",       -- 10% FC
    }

    -- TODO: Something for later probably
    -- sets.buff.immanence_dt = {}
end

----------------------------------------------------------------
-- HELPER FUNCTIONS 
----------------------------------------------------------------

function equip_set_and_weapon(set)
    equip(set)

    -- This will only add the current weapon set to sets that have neither a main weapon or a sub (like a shield)
    if not set.main and not set.sub then
        equip(weapon_sets[weapon_mode.current])
        return
    end
end

function idle()
    -- Choose between TP set and regular idle
    if toggle_tp == "On" and player.status == "Engaged" then
        equip_set_and_weapon(sets.melee.TP)
    else
        equip_set_and_weapon(sets.idle[idle_mode.current])

        if buffactive["Sublimation: Activated"] then
            equip(sets.buff.sublimation)
        end
    end

    -- Speed overlay
    if toggle_speed == "On" then
        equip({left_ring="Shneddick Ring",})
    end
end

-- This is for modes that are bound separately via subcommand.
-- It requires a mode pair table (so freenuke = "Free Nuke") that corresponds to the mode variable that you also pass in and a label for the output.
function handle_submode_switch(sub_command, mode_table, mode_var, label)
    if not sub_command then
        add_to_chat(123, "Missing argument.")
        return
    end

    local mode = mode_table[sub_command]
    if mode then
        add_to_chat(123, string.format("%s mode set to %s", label, mode))
        mode_var:set(mode)
    else
        add_to_chat(123, string.format("Invalid %s mode.", label))
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
    if toggle_speed == "On" then
        add_to_chat(123, "Consider disabling the speed toggle!")
    end

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
    local matched = false

    -- If Immanence is up and the spell is either a helix or elemental magic
    -- No need to use "matched", as I don't want to overlay this at all
    if buffactive["Immanence"] and spell.skill == "Elemental Magic" then
        equip_set_and_weapon(sets.buff.immanence)
        return
    end

    -- If the spell matches one of the match_list spells.
    for match in match_list:it() do
        if spell.name:match(match) then
            equip_set_and_weapon(sets.midcast[match])
            matched = true
            break
        end
    end

    -- If the spell name EXACTLY matches
    if not matched and sets.midcast[spell.name] then
        equip_set_and_weapon(sets.midcast[spell.name])
        matched = true
    end

    -- If the spell is a barspell
    if not matched and spell.name:match("^Bar") then
        equip_set_and_weapon(sets.midcast.barspell)
        matched = true
    end

    -- If the spell is a helix
    if not matched and helix_spells:contains(spell.name) then
        equip_set_and_weapon(sets.midcast.helix[nuking_mode.current])

        if spell.name:match("Noctohelix") then
            equip({head="Pixie Hairpin +1", left_ring="Archon Ring",})
        end

        if spell.name:match("Anemohelix") then
            equip({main={ name="Marin Staff +1", augments={'Path: A',}}, sub="Enki Strap",}) -- Possibly amend later to match a weapon set idk?
        end

        if spell.name:match("Luminohelix") then
            equip({main="Daybreak", sub="Ammurapi Shield",})
        end

        -- If I happen to get the item.
        --if spell.name:match("Geohelix") then
        --    equip({neck="Quanpur Necklace"})
        --end

        matched = true
    end

    -- If the spell skill is Elemental Magic
    if not matched and spell.skill == "Elemental Magic" then
        equip_set_and_weapon(sets.midcast[nuking_mode.current])
        matched = true
    end

    if spell.skill == "Enfeebling Magic" then
        if buffactive["Dark Arts"] or buffactive["Addendum: Black"] then
            equip(sets.midcast.enfeebling_dark)
            -- Specifically because AF body gives a buff if you're in Dark Arts
            matched = true
        else
            equip(sets.midcast.enfeebling_light)
            -- Also covering the instance that you're not in any art at all for some reason
            matched = true
        end
    end

    -- If the spell skill has a relevant set
    if not matched and sets.midcast[spell.skill] then
        equip_set_and_weapon(sets.midcast[spell.skill])
        matched = true
    end

    -- Any other spell (trusts?)
    if not matched and spell.action_type == "Magic" then
        idle()
    end

    -- Hachirin-no-Obi overlay
    if S{"Elemental Magic","Healing Magic", "Dark Magic"}:contains(spell.skill) and S{world.weather_element, world.day_element}:contains(spell.element) and spell.element ~= "None" then
        -- This will still trigger on stuff like Klimaform but eeh
        equip({waist="Hachirin-no-Obi"})
        
        if spell.skill == "Healing Magic" then
            equip({main="Chatoyant Staff", sub="Khonsu",})
        end
    end
end

function aftercast(spell)
    idle()
end

function buff_change(name, gain, buff_details)
    if not midaction() then
        if name == "Sublimation: Activated" then
            idle() 
        end
    end
end

function status_change(new, old)
    idle()
end

function sub_job_change(new,old)
    update_macro_book()
end

function self_command(command)
    -- Lowercase and split
    local commandArgs = T(command:lower():split(" "))
    local main_command = commandArgs[1]
    local sub_command = commandArgs[2]

    if main_command == "nukemode" then
        handle_submode_switch(sub_command, nuking_mode_pairs, nuking_mode, "Nuking")

    elseif main_command == "weaponmode" then
        weapon_mode:cycle()
        add_to_chat(123, string.format("Weapon mode set to %s", weapon_mode.current))
        idle()

    elseif main_command == "idlemode" then
        idle_mode:cycle()
        add_to_chat(123, string.format("Idle mode set to %s", idle_mode.current))
        idle()

    elseif main_command == "toggletp" then
        toggle_tp = handle_toggle(toggle_tp, "TP")

        idle()

        if toggle_tp == "On" then
            equip(weapon_sets[weapon_mode.current])
            send_command("gs disable main;gs disable sub;gs disable range")
        else
            send_command("gs enable main;gs enable sub;gs enable range")
        end

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
    send_command("unbind f2")
    send_command("unbind f3")
    
    send_command("unbind f5")
    send_command("unbind f6")
    send_command("unbind f7")
    
    send_command("unbind f9")

    send_command("unbind f11")
    send_command("unbind f12")
end