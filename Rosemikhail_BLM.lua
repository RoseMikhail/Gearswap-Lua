---@diagnostic disable: lowercase-global, undefined-global
include("Modes.lua")

-- Modes
nuking_mode = M{"Free Nuke", "Burst", "Occult Acumen"}
idle_mode = M{"PDT", "MDT", "Refresh"}
weapon_mode = M{"Staff", "StaffAcc", "Daybreak", "Wizard"}
-- TODO: As long as StaffAcc exists with Khonsu in it, dirty Mana Wall checks to not equip Khonsu will exist lol

-- Midcast helpers
match_list = S{"Cure", "Aspir", "Drain", "Regen"}
elemental_debuffs = S{'Burn','Frost','Choke','Rasp','Shock','Drown'}
cumulative_spells = S{'Stoneja','Waterja','Aeroja','Firaja','Blizzaja','Thundaja', 'Comet'}

-- Command helpers
nuking_mode_pairs = {
    freenuke = "Free Nuke",
    burst = "Burst",
    occultacumen = "Occult Acumen",
}

idle_mode_pairs = {
    mdt = "MDT",
    pdt = "PDT",
    refresh = "Refresh",
}

toggle_speed = "Off"
toggle_death = "Off"
toggle_af_body = "Off"

-- Bindings
send_command("bind f1 gs c nukemode freenuke")
send_command("bind f2 gs c nukemode burst")
send_command("bind f3 gs c nukemode occultacumen")
send_command("bind f4 gs c weaponmode")
send_command("bind f5 gs c idlemode pdt")
send_command("bind f6 gs c idlemode mdt")
send_command("bind f7 gs c idlemode refresh")
send_command("bind f9 gs c togglespeed")
send_command("bind f10 gs c toggleafbody")
send_command("bind f11 gs c toggledeath")
send_command("bind f12 gs c toggletextbox")

-- Help Text
add_to_chat(123, "BLM Lua")
add_to_chat(123, "F1-F3: Nuking modes")
add_to_chat(123, "F4: Weapon sets")
add_to_chat(123, "F5-F6: Idle modes")
add_to_chat(123, "F9: Toggle speed gear")
add_to_chat(123, "F10: Toggle AF body")
add_to_chat(123, "F11: Toggle Death")
add_to_chat(123, "F12: Hide information text box")

-- Information Box
default_settings = {
  bg = { alpha = 100 },
  pos = { x = -210, y = 21 },
  flags = { draggable = false, right = true },
  text = { font = "Arial", size = 13 },
}

text_box = texts.new(default_settings)
text_box:text("Mode: " .. nuking_mode.current .. " | Set: " .. weapon_mode.current .. " | Idle: " .. idle_mode.current .. " | Speed: " .. toggle_speed .. " | AF Body: " .. toggle_af_body .. " | Death: " .. toggle_death)
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
    ----------------------------------------------------------------
    -- GEAR PLACEHOLDERS
    ----------------------------------------------------------------
    
    jse = {}                       -- Leave this empty
    jse.AF = {}                    -- Leave this empty
    jse.relic = {}                 -- Leave this empty
    jse.empyrean = {}              -- Leave this empty
    jse.capes = {}                 -- Leave this empty

    jse.AF = {
        head="Spae. Petasos +1",
        body="Spae. Coat +4",
        hands="Spae. Gloves +4",
        legs="Spae. Tonban +3",
        feet="Spae. Sabots +2",
    }

    jse.relic = {
        head={ name="Arch. Petasos +1", augments={'Increases Ancient Magic damage and magic burst damage',}},
        body={ name="Arch. Coat +2", augments={'Enhances "Manafont" effect',}},
        hands={ name="Arch. Gloves +1", augments={'Increases Elemental Magic accuracy',}},
        legs={ name="Arch. Tonban +4", augments={'Increases Elemental Magic debuff time and potency',}},
        feet={ name="Arch. Sabots +2", augments={'Increases Aspir absorption amount',}},
    }

    jse.empyrean = {
        head="Wicce Petasos +2",
        body="Wicce Coat +2",
        hands="Wicce Gloves +2",
        legs="Wicce Chausses +3",
        feet="Wicce Sabots +2",
    }

    jse.capes = {
        nuking ={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
        idle_fc ={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        occult_acumen ={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Store TP"+10',}},
        --death ="",
        --enmity ="",
    }

    ----------------------------------------------------------------
    -- WEAPON SETS
    ----------------------------------------------------------------
    
    weapon_sets = {
        ["Staff"] = {
            main={ name="Marin Staff +1", augments={'Path: A',}},
            sub="Enki Strap",
        },
        ["StaffAcc"] = {
            main={ name="Marin Staff +1", augments={'Path: A',}},
            sub="Khonsu",
        },
        ["Daybreak"] = {
            main="Daybreak",
            sub="Ammurapi Shield",
        },
        ["Wizard"] = {
            main="Wizard's Rod",
            sub="Ammurapi Shield",
        },
    }

    ----------------------------------------------------------------
    -- GEAR SETS
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
        back=jse.capes.idle_fc,                                                                                                         -- 10% FC
    }

    sets.precast["Impact"] = set_combine(sets.precast.fast_cast, {
        head=empty,
        body="Crepuscular Cloak",
    })

    sets.precast["Death"] = set_combine(sets.precast.fast_cast, {
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
        ammo="Sroda Tathlum",
        head=jse.empyrean.head,
        body=jse.AF.body,
        hands=jse.empyrean.hands,
        legs=jse.empyrean.legs,
        feet=jse.empyrean.feet,
        neck="Saevus Pendant +1", -- Sorcerer's Stole +1/+2 (augmented)
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear="Barkaro. Earring", -- Regal Earring
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
        back=jse.capes.nuking
    }

    sets.midcast["Burst"] = {                                                                                           -- NEW: 43% MB (Capped), 16% MB II (NOW 36% MB, 16% MB II)
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Ea Hat",                                                                                                  -- 6% MB 6% MB II
        body=jse.empyrean.body,                                                                                         -- 4% MB II
        hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},                      -- 6% MB II
        legs=jse.empyrean.legs,                                                                                         -- 15% MB
        feet=jse.empyrean.feet,                                                                                         -- No Longer 7% MB    According to sim, it's actually better to ditch the Jhakri Pigaches +2 (and their 7% MB) in favour of Wicce
        neck="Mizukage-no-Kubikazari",                                                                                  -- 10% MB   This has no acc, maybe sacrifice a little mb and use Sorcerer's Stole +1/+2 (augmented)
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear="Barkaro. Earring",
        left_ring="Freke Ring",
        right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},                                                   -- I won't pretend to understand why this is better, but the sim says it is
        back=jse.capes.nuking                                                                                           -- 5% MB
    }

    sets.midcast["Occult Acumen"] = set_combine(sets.midcast["Free Nuke"], { -- I have no idea when it comes to Occult Acumen. Panic TP?
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
        back=jse.capes.occult_acumen,
    })

    sets.midcast.death_burst = set_combine(sets.midcast["Burst"], {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ring="Mephitas's Ring +1",
        right_ring="Mephitas's Ring",
        back=jse.capes.idle_fc, -- This wants to be a Death cape
    })

    sets.midcast.death_free_nuke = set_combine(sets.midcast["Free Nuke"], {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Pixie Hairpin +1",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ring="Mephitas's Ring +1",
        right_ring="Mephitas's Ring",
        back=jse.capes.idle_fc, -- This wants to be a Death cape
    })
    
    ----------------------------------------------------------------
    -- DAMAGE MIDCAST
    ----------------------------------------------------------------

    sets.midcast["Meteor"] = set_combine(sets.midcast["Free Nuke"], {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        body=jse.relic.body,
        hands=jse.AF.hands,                                            -- Replace with +3 Archmage hands if and when I get them...
        feet=jse.relic.feet,
        --left_ear="Ilmr Earring",                                     --  When I get one
    })

    sets.midcast["Comet"] = set_combine(sets.midcast["Free Nuke"], {
        head="Pixie Hairpin +1",
        -- TODO: Add Archon Ring when I get it
    })

    ----------------------------------------------------------------
    -- ENFEEBLING MIDCAST
    ----------------------------------------------------------------

    -- Eventually when I have more Wicce upgraded, they may end up beating out the Spaekona macc bonuses.
    sets.midcast["Enfeebling Magic"] = {
        ammo="Kalboron Stone",
        head=empty,
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands=jse.AF.hands,
        legs=jse.AF.legs,
        feet=jse.AF.feet,
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
        ammo="Kalboron Stone",
        head=empty,
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands=jse.AF.hands,
        legs=jse.relic.legs,
        feet=jse.relic.feet,
        neck="Incanter's Torque",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear={ name="Wicce Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.midcast["Dispelga"] = set_combine(sets.midcast["Enfeebling Magic"], {
        main="Daybreak",
        sub="Genmei Shield",
    })
    
    -- Impact likes more elemental magic skill
    sets.midcast["Impact"] = {
        ammo="Kalboron Stone",
        head=empty,
        body="Crepuscular Cloak",
        hands=jse.AF.hands,
        legs=jse.AF.legs,
        feet=jse.relic.feet,
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
        --ammo=
        head="Pixie Hairpin +1",
        --body=
        --hands=
        legs=jse.AF.legs,
        feet=jse.relic.feet,
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
        sub="Genmei Shield",
    })

    ----------------------------------------------------------------
    -- IDLE MODES
    ----------------------------------------------------------------

    sets.idle["PDT"] = {                                                                                                                                -- OVERALL -50% DT, -10% PDT, -3% MDT (-60% DT+PDT, -53% DT+MDT), +7-8 Refresh
        ammo="Staunch Tathlum",                                                                                                                         -- -2% DT
        head={ name="Merlinic Hood", augments={'DEX+11','Pet: "Store TP"+6','"Refresh"+2','Accuracy+16 Attack+16','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},    -- +2 Refresh
        body=jse.empyrean.body,                                                                                                                        -- +3 Refresh
        hands=jse.empyrean.hands,                                                                                                                      -- -12% DT
        legs="Assid. Pants +1",                                                                                                                         -- +1-2 Refresh
        feet=jse.empyrean.feet,                                                                                                                        -- -10% DT
        neck="Loricate Torque +1",                                                                                                                      -- -6% DT
        waist="Fucho-no-Obi",                                                                                                                           -- +1 Refresh
        left_ear="Etiolation Earring",                                                                                                                  -- -3% MDT
        right_ear="Nehalennia Earring",
        left_ring="Murky Ring",                                                                                                                         -- -10% DT
        right_ring="Defending Ring",                                                                                                                    -- -10% DT
        back=jse.capes.idle_fc,                                                                                                                        -- -10% PDT
    }

    sets.idle["MDT"] = set_combine(sets.idle["PDT"], {                                                                                                  -- OVERALL -54% DT, -0% PDT, -3% MDT (-54% DT+PDT, -57% DT+MDT) +5-6 Refresh
        head=jse.empyrean.head,                                                                                                                        -- -10% DT    
        neck="Warder's Charm +1",                                                                                                                       -- Reduction of 6% DT from base set
        back="Tuilha Cape",                                                                                                                             -- Reduction of 10% PDT from base set
    })

    sets.idle["Refresh"] = set_combine(sets.idle["PDT"], {                                                                                              -- OVERALL -33% DT, -10% PDT, -0% MDT (-43% DT+PDT, -33% DT+MDT), +9-10 refresh
        ammo="Staunch Tathlum",                                                                                                                         -- -2% DT
        head={ name="Merlinic Hood", augments={'DEX+11','Pet: "Store TP"+6','"Refresh"+2','Accuracy+16 Attack+16','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},    -- +2 Refresh
        body="Jhakri Robe +2",                                                                                                                          -- -0%      +4 Refresh
        hands="Serpentes Cuffs",                                                                                                                        -- -0%      +0.5 Refresh with Serpentes Sabots
        legs="Assid. Pants +1",                                                                                                                         --          1-2 Refresh (realistically 1)
        feet="Serpentes Sabots",                                                                                                                        -- -0%      +0.5 Refresh with Serpentes Cuffs
        neck="Loricate Torque +1",                                                                                                                      -- -6% DT
        waist="Fucho-no-Obi",                                                                                                                           -- -0%      +1 Refresh -- Maybe replace with Shinjutsu-no-Obi someday according to guide
        left_ear="Alabaster Earring",                                                                                                                   -- -5% DT
        right_ear="Nehalennia Earring",
        left_ring="Murky Ring",                                                                                                                         -- -10% DT
        right_ring="Defending Ring",                                                                                                                    -- -10% DT
        back=jse.capes.idle_fc,                                                                                                                        -- -10% PDT
    })

    sets.idle["Death"] = {
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head={ name="Kaabnax Hat", augments={'HP+30','MP+30','MP+30',}},
        body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
        hands=jse.AF.hands,
        legs=jse.AF.legs,
        feet="Serpentes Sabots",
        neck="Dualism Collar +1",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Etiolation Earring",
        right_ear="Nehalennia Earring",
        left_ring="Mephitas's Ring +1",
        right_ring="Mephitas's Ring",
        back=jse.capes.idle_fc, -- This wants a death cape eventually.
    }

    ----------------------------------------------------------------
    -- JOB ACTIONS 
    ----------------------------------------------------------------

    sets.ja["Manafont"] = {
        body=jse.relic.body,
    }

    sets.ja["Mana Wall"] = {                                                                                                            -- OVERALL -54% DT, -10% PDT, -3% MDT
        ammo="Staunch Tathlum",                                                                                                         -- -2% DT
        head=jse.empyrean.head,                                                                                                         -- -10% DT
        body=jse.AF.body,      -- Wicce +3 would probably be better if I wasn't casting. But I like casting and AF3 seems very convenient. Could maybe exception logic AFbody mode this later.
        hands=jse.empyrean.hands,                                                                                                       -- -12% DT
        legs=jse.empyrean.legs,                                                                                                         -- 
        feet=jse.empyrean.feet,                                                                                                         -- -10% DT
        neck="Unmoving Collar +1",
        waist="Slipor Sash",                                                                                                            -- -3% MDT
        left_ear="Ethereal Earring",                                                                                                    -- Damage to MP
        right_ear="Friomisi Earring",                                                                                                   -- Soon replaced but I won't say no to more damage during mana wall
        left_ring="Murky Ring",                                                                                                         -- -10% DT
        right_ring="Defending Ring",                                                                                                    -- -10% DT
        back=jse.capes.idle_fc,                                                                                                         -- -10% PDT
    }

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
        ammo="Strobilus",
        head={ name="Kaabnax Hat", augments={'HP+30','MP+30','MP+30',}},                                                                -- Want to replace with Amalric Coif +1 augmented
        body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
        hands=jse.AF.hands,
        legs=jse.AF.legs,                                                                                                               -- Want to replace with Amalric Slops +1 augmented
        feet=jse.AF.feet,                                                                                                               -- Want to replace with Psycloth Boots augmented
        neck="Dualism Collar +1",
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},
        left_ear="Nehalennia Earring",
        right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
        left_ring="Mephitas's Ring +1",
        right_ring="Mephitas's Ring",
        back=jse.capes.idle_fc,
    }
end

----------------------------------------------------------------
-- HELPER FUNCTIONS 
----------------------------------------------------------------

function equip_set_and_weapon(set)
    equip(set)
    -- This will only add a weapon set to sets that have neither a main weapon or a sub (like a shield)
    -- Not perfect, but simply make sure that sets either have both or neither
    if not set.main and not set.sub then
        equip(weapon_sets[weapon_mode.current])
        return
    end
end

function idle()
    -- Mana Wall
    if buffactive["Mana Wall"] then
        equip_set_and_weapon(sets.ja["Mana Wall"])

        -- Dirty check to avoid enmity decrease
        if weapon_sets[weapon_mode.current].sub == "Khonsu" then
            equip({sub="Enki Strap"})
        end
    -- Death
    elseif toggle_death == "On" then
        equip_set_and_weapon(sets.idle["Death"])
    else
        equip_set_and_weapon(sets.idle[idle_mode.current])
    end

    -- Consider NOT enabling this during Mana Wall. For now, just have eyes.
    if toggle_speed == "On" then
        equip({legs="Track Pants +1", feet=empty})
    end
end

----------------------------------------------------------------
-- GEARSWAP FUNCTIONS 
----------------------------------------------------------------
-- If a set has a main or a sub attached to it, it will use those instead.
-- To work with the weapon set cycling, a gear set must have neither.

function precast(spell)
    if toggle_speed == "On" then
        add_to_chat(123, "Consider disabling the speed toggle!")
    end

    -- Mana Wall
    if buffactive["Mana Wall"] then
        equip_set_and_weapon(sets.ja["Mana Wall"])

        -- Dirty check to avoid enmity decrease
        if weapon_sets[weapon_mode.current].sub == "Khonsu" then
            equip({sub="Enki Strap"})
        end
        return
    end

    -- Death
    if toggle_death == "On" and spell.action_type == "Magic" then
        equip_set_and_weapon(sets.precast["Death"])
        return
    end

    local matched_set

    if sets.ja[spell.name] then                 -- Job Abilities
        matched_set = sets.ja[spell.name]
    elseif sets.ws[spell.name] then             -- Weapon Skills
        matched_set = sets.ws[spell.name]
    elseif spell.type ~= "JobAbility" then      -- Avoid unhandled Job Abilities
        if spell.action_type == "Magic" then    -- Avoid unhandled Weapon Skills
            if sets.precast[spell.name] then    -- Specific spells
                matched_set = sets.precast[spell.name]
            else
                -- General purpose
                matched_set = sets.precast.fast_cast
            end
        --else
            -- Only Weapon Skill will go here. Any default Weapon Skill set would be here.
        end
    end

    if matched_set then
        equip_set_and_weapon(matched_set)
    else
        -- Eh, just in case you somehow don't have a weapon equipped and you for some reason need one, this'll solve that
        -- This is the "unhandled" scenario, so I'm okay with sitting in idle.
        idle()
    end
end

function midcast(spell)
    -- Mana Wall
    if buffactive["Mana Wall"] then
        if spell.name == "Stun" then
            --equip(sets.midcast.stun_enmity)
            equip_set_and_weapon(sets.midcast.stun_enmity)
        else
            --equip(sets.ja["Mana Wall"])
            equip_set_and_weapon(sets.ja["Mana Wall"])
        end

        -- Dirty check to avoid enmity decrease
        if weapon_sets[weapon_mode.current].sub == "Khonsu" then
            equip({sub="Enki Strap"})
        end
        return
    end

    -- Death
    if toggle_death == "On" then
        if spell.action_type == "Magic" then
            if nuking_mode.current == "Burst" then
                equip_set_and_weapon(sets.midcast.death_burst)
            else
                equip_set_and_weapon(sets.midcast.death_free_nuke)
            end
        end
        return
    end

    --local matched = false
    local matched_set

    -- If the spell matches one of the match_list spells.
    for match in match_list:it() do
        if spell.name:match(match) then
            matched_set = sets.midcast[match]
            break
        end
    end

    -- If the spell is Death
    if not matched_set and spell.name == "Death" then
        if nuking_mode.current == "Burst" then
            matched_set = sets.midcast.death_burst
        else
            matched_set = sets.midcast.death_free_nuke
        end
    end

    -- If the spell name EXACTLY matches.
    if not matched_set and sets.midcast[spell.name] then
        matched_set = sets.midcast[spell.name]
    end

    -- If the spell name is contained within elemental debuffs
    if not matched_set and elemental_debuffs:contains(spell.name) then
        matched_set = sets.midcast.elemental_debuff
    end

    -- If the spell skill is Elemental Magic
    if not matched_set and spell.skill == "Elemental Magic" then
        matched_set = sets.midcast[nuking_mode.current]
    end

    -- If the spell skill has a relevant set
    if not matched_set and sets.midcast[spell.skill] then
        matched_set = sets.midcast[spell.skill]
    end

    if matched_set then
        equip_set_and_weapon(matched_set)
    else
        -- Eh, just in case you somehow don't have a weapon equipped and you for some reason need one, this'll solve that
        -- This is the "unhandled" scenario, so I'm okay with sitting in idle.
        idle()
    end

    -- Empyrean leg overlay
    if cumulative_spells:contains(spell.name) then
        equip({legs=jse.empyrean.legs})
    end

    -- AF body overlay
    if toggle_af_body == "On" and spell.skill == "Elemental Magic" then
        equip({body=jse.AF.body})
    end

    -- Hachirin-no-Obi overlay
    if S{"Elemental Magic","Healing Magic", "Dark Magic"}:contains(spell.skill) and S{world.weather_element, world.day_element}:contains(spell.element) and spell.element ~= "None" then
        -- This will still trigger on stuff like Klimaform but eeh
        equip({waist="Hachirin-no-Obi"})
        -- Chatoyant staff check?
    end
end

function aftercast(spell)
    -- Gearswap will not immediately register Mana Wall's activation, so we skip this and wait for buff_change to handle the swap.
    if spell.name == "Mana Wall" then
        return
    end

    idle()
end

function buff_change(name, gain, buff_details)
    -- We wait until here to select gear, as Gearswap doesn't immediately register Mana Wall in aftercast.
    if name == "Mana Wall" and not midaction() then
        idle()
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

    local function handle_mode(mode_table, mode_var, label)
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

    if main_command == "nukemode" then
        handle_mode(nuking_mode_pairs, nuking_mode, "Nuking")
    elseif main_command == "weaponmode" then
        weapon_mode:cycle()
        idle()
        add_to_chat(123, string.format("Weapon mode set to %s", weapon_mode.current))
    elseif main_command == "idlemode" then
        handle_mode(idle_mode_pairs, idle_mode, "Idle")

        -- Only change if Mana Wall is not up and Death is off.
        if not buffactive["Mana Wall"] and toggle_death == "Off" then
            idle()
        end

    elseif main_command == "toggleafbody" then
        toggle_af_body = (toggle_af_body == "On") and "Off" or "On"
        add_to_chat(123, "AF Body toggle: " .. tostring(toggle_af_body))
    elseif main_command == "toggledeath" then
        toggle_death = (toggle_death == "On") and "Off" or "On"
        add_to_chat(123, "Death toggle: " .. toggle_death)

        -- Only change if Mana Wall is not up.
        if not buffactive["Mana Wall"] then
            idle()
        end
    elseif main_command == "togglespeed" then
        toggle_speed = (toggle_speed == "On") and "Off" or "On"
        idle()

        add_to_chat(123, "Speed toggle: " .. tostring(toggle_speed))
    elseif main_command == "toggletextbox" then
        text_box:visible(not text_box:visible())
    else
        add_to_chat(123, "Command not recognised.")
    end

    text_box:text("Nuke: " .. nuking_mode.current .. " | Set: " .. weapon_mode.current .. " | Idle: " .. idle_mode.current .. " | Speed: " .. toggle_speed .. " | AF Body: " .. toggle_af_body .. " | Death: " .. toggle_death)
end

function file_unload(file_name)
    send_command("unbind f1")
    send_command("unbind f2")
    send_command("unbind f3")
    send_command("unbind f4")
    
    send_command("unbind f5")
    send_command("unbind f6")
    send_command("unbind f7")
    
    send_command("unbind f9")
    send_command("unbind f10")
    send_command("unbind f11")
    send_command("unbind f12")
end