---@diagnostic disable: lowercase-global, undefined-global
include("Modes.lua")

-- Modes
nuking_mode = M{"Free Nuke", "Burst", "Occult Acumen"}
idle_mode = M{"PDT", "MDT", "Refresh"}

-- Global Variables
toggle_death = "Off"
toggle_af_body = "Off"

-- Bindings
send_command("bind f1 gs c nukemode freenuke")
send_command("bind f2 gs c nukemode burst")
send_command("bind f3 gs c nukemode occultacumen")
send_command("bind f5 gs c idlemode pdt")
send_command("bind f6 gs c idlemode mdt")
send_command("bind f7 gs c idlemode refresh")
send_command("bind f9 gs c toggleafbody")
send_command("bind f10 gs c toggledeath")
send_command("bind f12 gs c toggletextbox")

-- Help Text
add_to_chat(123, "F1-F3: Nuking modes, F5-F7: Idle modes")
add_to_chat(123, "F9: Toggle AF body, F10: Toggle Death")
add_to_chat(123, "F12: Hide information text box")

-- Information Box
default_settings = {
  bg = { alpha = 100 },
  pos = { x = -210, y = 21 },
  flags = { draggable = false, right = true },
  text = { font = "Arial", size = 13 },
}

text_box = texts.new(default_settings)
text_box:text("Nuke: " .. nuking_mode.current .. " | Idle: " .. idle_mode.current .. " | AF Body: " .. toggle_af_body .. " | Death: " .. toggle_death)
text_box:visible(true)

-- Lockstyle
send_command("wait 3;input /lockstyleset 5") -- Furia

function update_macro_book()
    -- BLM/SCH macro book
    send_command("input /macro book 1;input /macro set 1")
end

update_macro_book()

-- Individual spells should be added in the following way: sets.precast["Impact"]. This goes for precast and midcast.
function get_sets()

    -- Potentially have placeholders for grips/weapons
    -- gear.grips = {damage = "", accuracy = ""}

    ----------------------------------------------------------------
    -- GEAR PLACEHOLDERS
    ----------------------------------------------------------------
    gear = {}                       -- Leave this empty
    gear.AF = {}                    -- Leave this empty
    gear.relic = {}                 -- Leave this empty
    gear.empyrean = {}              -- Leave this empty
    gear.capes = {}                 -- Leave this empty

    gear.AF = {
        head="Spae. Petasos +1",
        body="Spae. Coat +4",
        hands="Spae. Gloves +3",
        legs="Spae. Tonban +3",
        feet="Spae. Sabots +2",
    }

    -- TODO: Hands... maybe... literally only for meteor...
    -- +2 hands in progress lol
    gear.relic = {
        head={ name="Arch. Petasos +1", augments={'Increases Ancient Magic damage and magic burst damage',}},
        body={ name="Arch. Coat +2", augments={'Enhances "Manafont" effect',}},
        hands={ name="Arch. Gloves +1", augments={'Increases Elemental Magic accuracy',}},
        legs={ name="Arch. Tonban +4", augments={'Increases Elemental Magic debuff time and potency',}},
        feet={ name="Arch. Sabots +2", augments={'Increases Aspir absorption amount',}},
    }

    gear.empyrean = {
        head="Wicce Petasos +2",
        body="Wicce Coat +2",
        hands="Wicce Gloves +2",
        legs="Wicce Chausses +3",
        feet="Wicce Sabots +2",
    }

    gear.capes = {
        nuking ={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
        idle_fc ={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        occult_acumen ={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Store TP"+10',}},
        death ="",
    }

    -- Add Merlinic / Telchine etc.

    ----------------------------------------------------------------
    -- SETS
    ----------------------------------------------------------------
    sets = {}
    sets.idle = {}                  -- Leave this empty
    sets.ws = {}                    -- Leave this empty
    sets.ja = {}                    -- Leave this empty
    sets.precast = {}               -- Leave this empty
    sets.midcast = {}               -- Leave this empty
    sets.aftercast = {}             -- Leave this empty

    ----------------------------------------------------------------
    -- PRECAST
    ----------------------------------------------------------------

    sets.precast.fast_cast = {                                                                                                          -- OVERALL 73% FC, 9% Elem FC, 5% Occ (Technically capped via Elemental Celerity, but 80% is better.)
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo="Impatiens",                                                                                                               -- 2% Occ
        head={ name="Merlinic Hood", augments={'"Fast Cast"+6','"Mag.Atk.Bns."+8',}},                                                   -- 14% FC
        body={ name="Merlinic Jubbah", augments={'Mag. Acc.+2','"Fast Cast"+7','INT+9','"Mag.Atk.Bns."+7',}},                           -- 13% FC
        hands="Mallquis Cuffs +2",                                                                                                      -- 6% Elem FC
        legs="Orvail Pants +1",                                                                                                         -- 5% FC
        feet={ name="Merlinic Crackows", augments={'"Fast Cast"+6','CHR+2','Mag. Acc.+8','"Mag.Atk.Bns."+11',}},                        -- 11% FC
        neck="Baetyl Pendant",                                                                                                          -- 4% FC
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},                                                                     -- 5% FC
        left_ear="Malignance Earring",                                                                                                  -- 4% FC
        right_ear="Loquacious Earring",                                                                                                 -- 2% FC
        left_ring="Weather. Ring",                                                                                                      -- 3% Elem FC
        right_ring="Mallquis Ring",                                                                                                     -- 5% FC 3% Occ
        back=gear.capes.idle_fc,                                                                                                        -- 10% FC
    }

    sets.precast["Impact"] = set_combine(sets.precast.fast_cast, {
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        head="",
        body="Crepuscular Cloak",
    })

    sets.precast["Death"] = set_combine(sets.precast.fast_cast, {
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        left_ring="Mephitas's Ring +1",
        right_ring="Mephitas's Ring",
    })

    sets.precast["Dispelga"] = set_combine(sets.precast.fast_cast, {
        main="Daybreak",
        sub="Genmei Shield",
    })

    ----------------------------------------------------------------
    -- NUKE MIDCAST MODES
    ----------------------------------------------------------------

    sets.midcast["Free Nuke"] = {
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo="Sroda Tathlum",
        head=gear.empyrean.head,
        body=gear.AF.body,
        hands=gear.empyrean.hands,
        legs=gear.empyrean.legs,
        feet=gear.empyrean.feet,
        neck="Saevus Pendant +1", -- Sorcerer's Stole +1/+2 (augmented)
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear="Barkaro. Earring", -- Regal Earring
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back=gear.capes.nuking
    }

    sets.midcast["Burst"] = {                                                                                           -- NEW: 43% MB (Capped), 16% MB II (NOW 36% MB, 16% MB II)
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",                                                                                               -- Khonsu is an alternative for accuracy
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Ea Hat",                                                                                                  -- 6% MB 6% MB II
        body=gear.empyrean.body,                                                                                        -- 4% MB II
        hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},                      -- 6% MB II
        legs=gear.empyrean.legs,                                                                                        -- 15% MB
        feet=gear.empyrean.feet,                                                                                        -- No Longer 7% MB    According to sim, it's actually better to ditch the Jhakri Pigaches +2 (and their 7% MB) in favour of Wicce
        neck="Mizukage-no-Kubikazari",                                                                                  -- 10% MB   This has no acc, maybe sacrifice a little mb and use Sorcerer's Stole +1/+2 (augmented)
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear="Barkaro. Earring",
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},                                                   -- I won't pretend to understand why this is better, but the sim says it is
        back=gear.capes.nuking                                                                                          -- 5% MB
    }

    sets.midcast["Occult Acumen"] = set_combine(sets.midcast["Free Nuke"], { -- I have no idea when it comes to Occult Acumen. Panic TP?
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        --ammo=
        head="Mallquis Chapeau +2",
        --body=
        --hands=
        legs= "Perdition Slops",
        feet="Battlecast Gaiters",
        --neck=,
        waist="Oneiros Rope",
        left_ear="Steelflash Earring",
        --right_ear=
        left_ring="Rajas Ring",
        --right_ring=
        back=gear.capes.occult_acumen,
    })

    sets.midcast.death_burst = set_combine(sets.midcast["Burst"], {
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ring="Mephitas's Ring +1",
        right_ring="Mephitas's Ring",
        back=gear.capes.idle_fc, -- This wants to be a Death cape
    })

    sets.midcast.death_free_nuke = set_combine(sets.midcast["Free Nuke"], {
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ring="Mephitas's Ring +1",
        right_ring="Mephitas's Ring",
        back=gear.capes.idle_fc, -- This wants to be a Death cape
    })
    
    ----------------------------------------------------------------
    -- DAMAGE MIDCAST
    ----------------------------------------------------------------

    -- TODO: Maybe make burst versions? Or just have the burst mode ignore these?

    sets.midcast["Meteor"] = set_combine(sets.midcast["Free Nuke"], {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        body=gear.relic.body,
        hands=gear.AF.hands,                                            -- Replace with +3 Archmage hands if and when I get them...
        feet=gear.relic.feet,
        --left_ear="Ilmr Earring",                                      --  When I get one
    })

    sets.midcast["Comet"] = set_combine(sets.midcast["Free Nuke"], {
        head="Pixie Hairpin +1",
        -- TODO: Add Archon Ring when I get it
    })

    ----------------------------------------------------------------
    -- ENFEEBLING MIDCAST
    ----------------------------------------------------------------
    
    --- Spaekona is great for the accuracy bonuses, though it will be beaten out later
    --- Put in the amounts of magic accuracy and elemental magic skill later
    --- Impact likes more elemental magic skill

    -- Eventually when I have more Wicce upgraded, they may end up beating out the Spaekona macc bonuses.
    sets.midcast["Enfeebling Magic"] = {
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo="Kalboron Stone",
        head="",
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands=gear.AF.hands,
        legs=gear.AF.legs,
        feet=gear.AF.feet,
        neck="Incanter's Torque",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear={ name="Wicce Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    -- Eventually this prefers Wicce+3 head and Spae body for the slightly higher elemental magic skill + accuracy, it seems...
    sets.midcast.elemental_debuff = {
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo="Kalboron Stone",
        head="",
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands=gear.AF.hands,
        legs=gear.relic.legs,
        feet=gear.relic.feet,
        neck="Incanter's Torque",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear={ name="Wicce Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.midcast["Dispelga"] = set_combine(sets.midcast.enfeebling, {
        main="Daybreak",
        sub="Genmei Shield",
    })
    
    sets.midcast["Impact"] = {
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo="Kalboron Stone",
        head="",
        body="Crepuscular Cloak",
        hands=gear.AF.hands,
        legs=gear.AF.legs,
        feet=gear.relic.feet,
        neck="Incanter's Torque",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear={ name="Wicce Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    ----------------------------------------------------------------
    -- OTHER MIDCAST
    ----------------------------------------------------------------

    sets.midcast["Cure"] = set_combine(sets.midcast["Free Nuke"], {                                                                 -- Overall +50%
        main="Daybreak",                                                                                                            -- 30%
        sub="Genmei Shield",
        ammo="Kalboron Stone",
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},      -- +10%
        body={ name="Vanya Robe", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        hands={ name="Vanya Cuffs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},     -- +5%
        neck="Incanter's Torque",
        waist="Rumination Sash",
        left_ear="Mendi. Earring",                                                                                                  -- +5%
        right_ear="Meili Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    })

    sets.midcast["Enhancing Magic"] = set_combine(sets.midcast["Free Nuke"], {                                                      -- +54% duration
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo="Staunch Tathlum",
        head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +8',}},                                                          -- +8% duration
        body={ name="Telchine Chas.", augments={'Pet: "Regen"+3','Enh. Mag. eff. dur. +10',}},                                      -- +10% duration
        hands={ name="Telchine Gloves", augments={'Pet: "Regen"+3','Enh. Mag. eff. dur. +9',}},                                     -- +9% duration
        legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +8',}},                                                      -- +8% duration
        feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +9',}},                                                     -- +9% duration
        neck="Incanter's Torque",
        waist="Embla Sash",                                                                                                         -- +10% duration
        left_ear="Mendi. Earring",
        right_ear="Gwati Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    })

    sets.midcast["Aspir"] = set_combine(sets.midcast["Free Nuke"], {
        --main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}}, -- I'll be real, this cucks Myrkr way too much
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        --sub=
        --ammo=
        head="Pixie Hairpin +1",
        --body=
        --hands=
        legs=gear.AF.legs,
        feet=gear.relic.feet,
        neck="Dark Torque",
        waist="Fucho-no-Obi",
        --left_ear=
        --right_ear=
        left_ring="Evanescence Ring",
        --right_ring=
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    })

    sets.midcast["Drain"] = sets.midcast["Aspir"]

    sets.midcast["Regen"] = set_combine(sets.midcast["Enhancing Magic"], {
        main="Bolelabunga",                                                                                                         -- 10% potency
    })

    ----------------------------------------------------------------
    -- IDLE MODES
    ----------------------------------------------------------------

    -- Capped on damage taken
    sets.idle["PDT"] = {                                                                                                                -- OVERALL -50% DT, -10% PDT, -3% MDT (-60% DT+PDT, -53% DT+MDT), +6-7 Refresh
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo="Staunch Tathlum",                                                                                                         -- -2% DT
        head="Befouled Crown",                                                                                                          -- +1 Refresh
        body=gear.empyrean.body,                                                                                                        -- +3 Refresh
        hands=gear.empyrean.hands,                                                                                                      -- -12% DT
        legs="Assid. Pants +1",                                                                                                         -- +1-2 Refresh
        feet=gear.empyrean.feet,                                                                                                        -- -10% DT
        neck="Loricate Torque +1",                                                                                                      -- -6% DT
        waist="Fucho-no-Obi",                                                                                                           -- +1 Refresh
        left_ear="Etiolation Earring",                                                                                                  -- -3% MDT
        right_ear="Nehalennia Earring",
        left_ring="Murky Ring",                                                                                                         -- -10% DT
        right_ring="Defending Ring",                                                                                                    -- -10% DT
        back=gear.capes.idle_fc,                                                                                                        -- -10% PDT
    }

    sets.idle["MDT"] = set_combine(sets.idle["PDT"], {                                                                                  -- OVERALL -54% DT, -0% PDT, -3% MDT (-54% DT+PDT, -57% DT+MDT) +5-6 Refresh
        head=gear.empyrean.head,                                                                                                        -- -10% DT    
        neck="Warder's Charm +1",                                                                                                       -- Reduction of 6% DT from base set
        back="Tuilha Cape",                                                                                                             -- Reduction of 10% PDT from base set
    })

    sets.idle["Refresh"] = set_combine(sets.idle["PDT"], {                                                                              -- OVERALL -33% DT, -10% PDT, -0% MDT (-43% DT+PDT, -33% DT+MDT), +8-9 refresh
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo="Staunch Tathlum",                                                                                                         -- -2% DT
        head="Befouled Crown",                                                                                                          -- -0%      +1 Refresh
        body="Jhakri Robe +2",                                                                                                          -- -0%      +4 Refresh
        hands="Serpentes Cuffs",                                                                                                        -- -0%      +0.5 Refresh with Serpentes Sabots
        legs="Assid. Pants +1",                                                                                                         --          1-2 Refresh (realistically 1)
        feet="Serpentes Sabots",                                                                                                        -- -0%      +0.5 Refresh with Serpentes Cuffs
        neck="Loricate Torque +1",                                                                                                      -- -6% DT
        waist="Fucho-no-Obi",                                                                                                           -- -0%      +1 Refresh -- Maybe replace with Shinjutsu-no-Obi someday according to guide
        left_ear="Alabaster Earring",                                                                                                   -- -5% DT
        right_ear="Nehalennia Earring",
        left_ring="Murky Ring",                                                                                                         -- -10% DT
        right_ring="Defending Ring",                                                                                                    -- -10% DT
        back=gear.capes.idle_fc,                                                                                                        -- -10% PDT
    })

    -- I guess just aim for maximum MP possible? Idk how to sort out my precast/midcast stuff with this hehe
    sets.idle["Death"] = {
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Kaabnax Hat", augments={'HP+30','MP+30','MP+30',}},
        body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
        hands=gear.AF.hands,
        legs=gear.AF.legs,
        feet="Serpentes Sabots",
        neck="Dualism Collar +1",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Etiolation Earring",
        right_ear="Nehalennia Earring",
        left_ring="Mephitas's Ring +1",
        right_ring="Mephitas's Ring",
        back=gear.capes.idle_fc, -- This wants a death cape eventually.
    }

    ----------------------------------------------------------------
    -- JOB ACTIONS 
    ----------------------------------------------------------------

    sets.ja["Manafont"] = {
        body=gear.relic.body,
    }

    sets.ja["Mana Wall"] = {                                                                                                            -- OVERALL -54% DT, -10% PDT, -3% MDT
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo="Staunch Tathlum",                                                                                                         -- -2% DT
        head=gear.empyrean.head,                                                                                                        -- -10% DT
        body=gear.AF.body,      -- Wicce +3 would probably be better if I wasn't casting. But I like casting and AF3 seems very convenient. Could maybe exception logic AFbody mode this later.
        hands=gear.empyrean.hands,                                                                                                      -- -12% DT
        legs=gear.empyrean.legs,                                                                                                        -- 
        feet=gear.empyrean.feet,                                                                                                        -- -10% DT
        neck="Unmoving Collar +1",
        waist="Slipor Sash",                                                                                                            -- -3% MDT
        left_ear="Ethereal Earring",                                                                                                    -- Damage to MP
        right_ear="Friomisi Earring",                                                                                                   -- Soon replaced but I won't say no to more damage during mana wall
        left_ring="Murky Ring",                                                                                                         -- -10% DT
        right_ring="Defending Ring",                                                                                                    -- -10% DT
        back=gear.capes.idle_fc,                                                                                                        -- -10% PDT
    }

    -- TODO: Need to add a Taranus cape that has enmity on it
    sets.midcast.stun_enmity = set_combine(sets.ja["Mana Wall"], {  -- OVERALL +19 enmity
        left_ring="Vengeful Ring",                                  -- +3 enmity
        neck="Unmoving Collar +1",                                  -- +10 enmity
        left_ear="Cryptic Earring",                                 -- +4 enmity 
        right_ear="Friomisi Earring",                               -- +2 enmity
    })

    ----------------------------------------------------------------
    -- WEAPONSKILLS 
    ----------------------------------------------------------------

    sets.ws["Myrkr"] = {
        main={ name="Marin Staff +1", augments={'Path: A',}},
        sub="Khonsu",
        ammo="Strobilus",
        head={ name="Kaabnax Hat", augments={'HP+30','MP+30','MP+30',}},                                                                -- Want to replace with Amalric Coif +1 augmented
        body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
        hands=gear.AF.hands,
        legs=gear.AF.legs,                                                                                                              -- Want to replace with Amalric Slops +1 augmented
        feet=gear.AF.feet,                                                                                                              -- Want to replace with Psycloth Boots augmented
        neck="Dualism Collar +1",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Nehalennia Earring",
        right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
        left_ring="Mephitas's Ring +1",
        right_ring="Mephitas's Ring",
        back=gear.capes.idle_fc,
    }
end

----------------------------------------------------------------
-- LOGIC 
----------------------------------------------------------------

-- TODO: Maybe make an exception for impact/elemental magic in my Death logic somehow... later.

function precast(spell)
    -- Mana Wall
    if buffactive["Mana Wall"] then
        equip(sets.ja["Mana Wall"])
        return
    end

    -- Death
    if toggle_death == "On" then
        if spell.action_type == "Magic" then
            equip(sets.precast["Death"])
        end
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

function midcast(spell)
    -- Mana Wall
    if buffactive["Mana Wall"] then
        if spell.name == "Stun" then
            equip(sets.midcast.stun_enmity)
        else
            equip(sets.ja["Mana Wall"])
        end
        return
    end

    -- Death
    if toggle_death == "On" then
        if spell.action_type == "Magic" then
            if nuking_mode.current == "Burst" then
                equip(sets.midcast.death_burst)
            else
                equip(sets.midcast.death_free_nuke)
            end
        end
        return
    end

    local elemental_debuffs = S{'Burn','Frost','Choke','Rasp','Shock','Drown'}
    local cumulative_spells = S{'Stoneja','Waterja','Aeroja','Firaja','Blizzaja','Thundaja', 'Comet'}
    local match_list = S{"Cure", "Aspir", "Drain", "Regen"}
    local matched = false

    -- If the spell matches one of the match_list spells.
    for match in match_list:it() do
        if spell.name:match(match) then
            equip(sets.midcast[match])
            matched = true
            break
        end
    end

    -- If the spell is Death
    if not matched and spell.name == "Death" then
        if nuking_mode.current == "Burst" then
            equip(sets.midcast.death_burst)
        else
            equip(sets.midcast.death_free_nuke)
        end

        matched = true
    end

    -- If the spell name EXACTLY matches.
    if not matched and sets.midcast[spell.name] then
        equip(sets.midcast[spell.name])
        matched = true
    end

    -- If the spell name is contained within elemental debuffs
    if not matched and elemental_debuffs:contains(spell.name) then
        equip(sets.midcast.elemental_debuff)
        matched = true
    end

    -- If the spell skill is Elemental Magic
    if not matched and spell.skill == "Elemental Magic" then
        equip(sets.midcast[nuking_mode.current])
        
        if cumulative_spells:contains(spell.name) then
            equip({legs=gear.empyrean.legs})
        end

        if toggle_af_body == "On" then
            equip({body=gear.AF.body})
        end

        matched = true
    end

    -- If the spell skill has a relevant set
    if not matched and sets.midcast[spell.skill] then
        equip(sets.midcast[spell.skill])
        matched = true
    end

    -- If the magic is literally anything else
    if not matched and spell.action_type == "Magic" then
        idle()
        --matched = true
    end

    -- Equip the Hachirin-no-Obi on top of whatever was selected.
    if S{"Elemental Magic","Healing Magic", "Dark Magic"}:contains(spell.skill) and S{world.weather_element, world.day_element}:contains(spell.element) then
        -- This will still trigger on stuff like Klimaform but eeh
        equip({waist="Hachirin-no-Obi"})

        -- Chatoyant staff check?
    end
end

function idle()
    -- Mana Wall
    if buffactive["Mana Wall"] then
        equip(sets.ja["Mana Wall"])
        return
    end

    -- Death
    if toggle_death == "On" then
        equip(sets.idle["Death"])
        return
    end

    equip(sets.idle[idle_mode.current])
end

function aftercast(spell)
    -- Gearswap will not immediately register Mana Wall's activation, so we skip this and wait for buff_change to handle the swap.
    if spell.name == "Mana Wall" then
        return
    end

    idle()
end

function buff_change(name, gain, buff_details)
    -- We switch to the Mana Wall gear here, as Gearswap will not immediately register the buff's activation.
    -- Upon losing Mana Wall, we will switch to either a normal idle or Death set.
    if name == "Mana Wall" then
        if gain == true then
            equip(sets.ja["Mana Wall"])
        elseif gain == false then
            if not midaction() then
                -- Death
                if toggle_death == "On" then
                    equip(sets.idle["Death"])
                    return
                end

                equip(sets.idle[idle_mode.current])
            end
        end
    end
end

function status_change(new, old)
    idle()
end

function sub_job_change(new,old)
    update_macro_book()
end

-- This needs cleaning up - I could definitely break this into small functions.
function self_command(command)
    local commandArgs = command

    if #commandArgs:split(" ") >= 1 then
        commandArgs = T(commandArgs:split(" "))
    end

    if commandArgs[1]:lower() == "nukemode" then
        if commandArgs[2] then
            if commandArgs[2]:lower() == "freenuke" then
                nuking_mode:set("Free Nuke")
            elseif commandArgs[2]:lower() == "burst" then
                nuking_mode:set("Burst")
            elseif commandArgs[2]:lower() == "occultacumen" then
                nuking_mode:set("Occult Acumen")
            else
                add_to_chat(123, "Argument not recognized.")
                return
            end

            add_to_chat(123, "Switching Nuking mode to " .. nuking_mode.current)
        else
            add_to_chat(123, "Missing argument.")
        end
    elseif commandArgs[1]:lower() == "idlemode" then
        if commandArgs[2] then
            if commandArgs[2]:lower() == "pdt" then
                idle_mode:set("PDT")
            elseif commandArgs[2]:lower() == "mdt" then
                idle_mode:set("MDT")
            elseif commandArgs[2]:lower() == "refresh" then
                idle_mode:set("Refresh")
            else
                add_to_chat(123, "Argument not recognized.")
                return
            end

            add_to_chat(123, "Switching Idle mode to " .. idle_mode.current)

            -- Mana Wall / Death
            if buffactive["Mana Wall"] or toggle_death == "On" then
                if buffactive["Mana Wall"] then
                    add_to_chat(123, "Idle gear will not switch due to Mana Wall.")
                elseif toggle_death == "On" then
                    add_to_chat(123, "Idle gear will not switch due to Death toggle mode.")
                end
            else
                equip(sets.idle[idle_mode.current])
            end
        else
            add_to_chat(123, "Missing argument.")
        end
    elseif commandArgs[1]:lower() == "toggleafbody" then
        if toggle_af_body == "On" then
            toggle_af_body = "Off"
        elseif toggle_af_body == "Off" then
            toggle_af_body = "On"
        end
        add_to_chat(123, "AF Body toggle: " .. tostring(toggle_af_body))
    elseif commandArgs[1]:lower() == "toggledeath" then
        if toggle_death == "On" then
            toggle_death = "Off"

            -- Mana Wall
            if buffactive["Mana Wall"] then
                add_to_chat(123, "Idle gear will not switch due to Mana Wall.")
            else
                equip(sets.idle[idle_mode.current])
            end
        elseif toggle_death == "Off" then
            toggle_death = "On"

            -- Mana Wall
            if buffactive["Mana Wall"] then
                add_to_chat(123, "Idle gear will not switch due to Mana Wall.")
            else
                equip(sets.idle["Death"])
            end
        end

        add_to_chat(123, "Death toggle: " .. toggle_death)
    elseif commandArgs[1]:lower() == "toggletextbox" then
        if text_box:visible() == true then
            text_box:visible(false)
        else
            text_box:visible(true)
        end
    else
        add_to_chat(123, "Command not recognised.")
    end

    text_box:text("Nuke: " .. nuking_mode.current .. " | Idle: " .. idle_mode.current .. " | AF Body: " .. toggle_af_body .. " | Death: " .. toggle_death)

    --[[ mine
    local nuke_mode_list = {
        [0] = {command = "freenuke", mode="Free Nuke"},
        [1] = {command = "burst", mode="Burst"},
        [2] = {command = "occultacumen", mode="Occult Acumen"},
    }

    local main_argument = commandArgs[1]:lower()
    local sub_argument = commandArgs[2]:lower()

    if main_argument == "nukemode" then
        local sub_match = nil

        for id, mode in pairs(nuke_mode_list) do
            if mode.command == sub_argument then
                add_to_chat(123, string.format("%s is the command. %s is the mode name", mode.command, mode.mode))
                sub_match = id
                break
            end
        end

        if sub_match then
            nuking_mode:set(nuke_mode_list[sub_match].mode)
            text_box:text("Nuke: " .. nuking_mode.current .. " | Idle: " .. idle_mode.current .. " | AF Body: " .. toggle_af_body .. " | Death: " .. toggle_death)
            return
        else
            add_to_chat(123, "Argument not recognized.")
            return
        end
    end
    ]]

    --[[ garbage
    local args = T(command:split(" "))
    local cmd = args[1] and args[1]:lower()
    local arg = args[2] and args[2]:lower()

    local nuking_modes = {
        freenuke = "Free Nuke",
        burst = "Burst",
        occultacumen = "Occult Acumen"
    }

    local idle_modes = {
        pdt = "PDT",
        mdt = "MDT",
        refresh = "Refresh"
    }

    if cmd == "nukemode" then
        if arg and nuking_modes[arg] then
            nuking_mode:set(nuking_modes[arg])
            add_to_chat(123, "Switching Nuking mode to " .. nuking_mode.current)
        else
            add_to_chat(123, arg and "Argument not recognized." or "Missing argument.")
        end

    elseif cmd == "idlemode" then
        if arg and idle_modes[arg] then
            idle_mode:set(idle_modes[arg])
            add_to_chat(123, "Switching Idle mode to " .. idle_mode.current)

            if buffactive["Mana Wall"] or toggle_death == "On" then
                local reason = buffactive["Mana Wall"] and "Mana Wall" or "Death toggle mode"
                add_to_chat(123, "Idle gear will not switch due to " .. reason .. ".")
            else
                equip(sets.idle[idle_mode.current])
            end
        else
            add_to_chat(123, arg and "Argument not recognized." or "Missing argument.")
        end

    elseif cmd == "toggleafbody" then
        toggle_af_body = (toggle_af_body == "On") and "Off" or "On"
        add_to_chat(123, "AF Body toggle: " .. toggle_af_body)

    elseif cmd == "toggledeath" then
        toggle_death = (toggle_death == "On") and "Off" or "On"
        local mode = (toggle_death == "On") and "Death" or idle_mode.current

        if buffactive["Mana Wall"] then
            add_to_chat(123, "Idle gear will not switch due to Mana Wall.")
        else
            equip(sets.idle[mode])
        end

        add_to_chat(123, "Death toggle: " .. toggle_death)

    elseif cmd == "toggletextbox" then
        text_box:visible(not text_box:visible())

    else
        add_to_chat(123, "Command not recognised.")
    end

    text_box:text("Nuke: " .. nuking_mode.current .. " | Idle: " .. idle_mode.current .. " | AF Body: " .. toggle_af_body .. " | Death: " .. toggle_death)
]]
end

function file_unload(file_name)
    send_command("unbind f1")
    send_command("unbind f2")
    send_command("unbind f3")
    
    send_command("unbind f5")
    send_command("unbind f6")
    send_command("unbind f7")
    
    send_command("unbind f9")
    send_command("unbind f10")
    send_command("unbind f12")
end