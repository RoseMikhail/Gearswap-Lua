---@diagnostic disable: lowercase-global, undefined-global
include("Modes.lua")

-- Modes
nuking_mode = M{"Free Nuke", "Burst"}
idle_mode = M{"PDT", "MDT"}

-- Command Helpers
nuking_mode_pairs = {
    freenuke = "Free Nuke",
    burst = "Burst",
}

idle_mode_pairs = {
    mdt = "MDT",
    pdt = "PDT",
    --refresh = "Refresh",
}

toggle_af_feet = "Off"

-- Bindings
send_command("bind f1 gs c nukemode freenuke")
send_command("bind f2 gs c nukemode burst")
send_command("bind f5 gs c idlemode pdt")
send_command("bind f6 gs c idlemode mdt")
send_command("bind f9 gs c toggleaffeet")
send_command("bind f12 gs c toggletextbox")

-- Help Text
add_to_chat(123, "F1-F2: Nuking modes, F5-F6: Idle modes")
add_to_chat(123, "F9: Toggle AF feet")
add_to_chat(123, "F12: Hide information text box")

-- Information Box
default_settings = {
  bg = { alpha = 100 },
  pos = { x = -210, y = 21 },
  flags = { draggable = false, right = true },
  text = { font = "Arial", size = 13 },
}

text_box = texts.new(default_settings)
text_box:text("Nuke: " .. nuking_mode.current .. " | Idle: " .. idle_mode.current .. " | AF Feet: " .. toggle_af_feet)
text_box:visible(true)

-- Lockstyle
send_command("wait 3;input /lockstyleset 22") -- Geomancer Relic

function update_macro_book()
    -- GEO/RDM macro book
    send_command("input /macro book 2;input /macro set 1")
end

update_macro_book()

-- Someday TODO: When I have Idris, I need a buff check for Entrust as Geomancy+ doesn't affect it. I will need to use my Gada +10% indocolore duration.
-- Potentially make an override to force the PDT idle set regardless of whether I have a bubble out.

-- Individual spells should be added in the following way: sets.precast["Impact"]. This goes for precast and midcast.
function get_sets()
    ----------------------------------------------------------------
    -- GEAR PLACEHOLDERS
    ----------------------------------------------------------------
    gear = {}                       -- Leave this empty
    gear.AF = {}                    -- Leave this empty
    gear.relic = {}                 -- Leave this empty
    gear.empyrean = {}              -- Leave this empty
    gear.capes = {}                 -- Leave this empty

    gear.AF = {
        head = "Geo. Galero +1",
        body = "Geomancy Tunic +3",
        hands = "Geo. Mitaines +3",
        legs = "Geo. Pants +1",
        feet = "Geo. Sandals +3",
    }

    gear.relic = {
        head = "Bagua Galero",
        body = "Bagua Tunic",
        hands = "Bagua Mitaines",
        legs = { name="Bagua Pants +2", augments={'Enhances "Mending Halation" effect',}},
        feet = { name="Bagua Sandals +1", augments={'Enhances "Radial Arcana" effect',}},
    }

    gear.empyrean = {
        head = "Azimuth Hood +2",
        body = "Azimuth Coat +2",
        hands = "Azimuth Gloves +2",
        legs = "Azimuth Tights +2",
        feet = "Azimuth Gaiters +2",
    }

    gear.capes = {
        luopan = { name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Evasion+10','Pet: "Regen"+10','Pet: "Regen"+5',}},
        idle = { name="Nantosuelta's Cape", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Evasion+10','Pet: "Regen"+10','Phys. dmg. taken-10%',}},
        nuking = { name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
        enfeebling_healing_fc = { name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }

    -- Add Merlinic
    -- Add Telchine when I have an enhancing set

    ----------------------------------------------------------------
    -- SETS
    ----------------------------------------------------------------

    sets = {}
    sets.idle = {}                  -- Leave this empty
    sets.ws = {}                    -- Leave this empty
    sets.ja = {}                    -- Leave this empty
    sets.precast = {}               -- Leave this empty
    sets.midcast = {}               -- Leave this empty
    sets.aftercast = {}             -- Leave this empty]

    ----------------------------------------------------------------
    -- PRECAST
    ----------------------------------------------------------------

    sets.precast.fast_cast = {                                                                                                          -- OVERALL 87% FC, 14% Elem FC, 3% Occ
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},                                    -- 5% FC
        sub="Genmei Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},                                                      -- 3% FC
        ammo=empty,
        head={ name="Merlinic Hood", augments={'"Fast Cast"+6','"Mag.Atk.Bns."+8',}},                                                   -- 14% FC
        body={ name="Merlinic Jubbah", augments={'Mag. Acc.+2','"Fast Cast"+7','INT+9','"Mag.Atk.Bns."+7',}},                           -- 13% FC
        hands=gear.relic.hands,                                                                                                         -- 11% Elem FC
        legs=gear.AF.legs,                                                                                                              -- 11% FC
        feet={ name="Merlinic Crackows", augments={'"Fast Cast"+6','CHR+2','Mag. Acc.+8','"Mag.Atk.Bns."+11',}},                        -- 11% FC
        neck="Baetyl Pendant",                                                                                                          -- 4% FC
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},                                                                     -- 5% FC
        left_ear="Malignance Earring",                                                                                                  -- 4% FC
        right_ear="Loquacious Earring",                                                                                                 -- 2% FC
        left_ring="Weather. Ring",                                                                                                      -- 5% FC 3% Occ
        right_ring="Mallquis Ring",                                                                                                     -- 3% Elem FC
        back=gear.capes.enfeebling_healing_fc,                                                                                          -- 10% FC
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

    sets.midcast["Free Nuke"] = {
        main="Daybreak",
        sub="Ammurapi Shield",
        range=empty,
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head=gear.empyrean.head,
        body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
        hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
        legs=gear.empyrean.legs,
        feet=gear.empyrean.feet,
        neck="Saevus Pendant +1",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear="Barkaro. Earring",
        left_ring="Freke Ring",
        right_ring="Jhakri Ring", -- Metamorph Ring +1
        back=gear.capes.nuking,
    }

    -- Picking up more of the Ea set might make this better, but it isn't a priority.
    sets.midcast["Burst"] = {                                                                           -- 35% MB, 24% MB II
        main="Daybreak",
        sub="Ammurapi Shield",
        range=empty,
        ammo={ name="Ghastly Tathlum +1", augments={'Path: A',}},
        head="Ea Hat",                                                                                  -- 6% MB 6% MB II
        body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},      -- Someday Ea +1 apparently
        hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},      -- 6% MB II
        legs="Ea Slops",                                                                                -- 7% MB 7% MB II
        feet="Jhakri Pigaches +2",                                                                      -- 7% MB
        neck="Mizu. Kubikazari",                                                                        -- 10% MB
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear="Barkaro. Earring",
        left_ring="Locus Ring",                                                                         -- 5% MB Eventually replace this ring with Freke when I'm at 40%+ mb cap and other gear puts by over by 5%
        right_ring="Mujin Band",                                                                        -- 5% MB II
        back=gear.capes.nuking
    }

    ----------------------------------------------------------------
    -- COLURE MIDCAST
    ----------------------------------------------------------------
    
    -- Can probably pull some of the skill gear out and replace with idle or conserve mp gear
    -- GEO SET CONSERVE MP: 43(GEO)+6+4+15+2 = 70%
    -- INDI SET CONSERVE MP: 43(GEO)+15+2 = 60%
    
    sets.midcast.geocolure = set_combine(sets.idle[idle_mode.current], {                                                        -- 940 total at present
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},                            -- Skill, 6% Conserve MP
        sub="Genmei Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},                                              -- Skill
        ammo=empty,
        head=gear.empyrean.head,                                                                                                -- Skill, Set: MP occasionally not depleted when using geomancy spells.
        body=gear.relic.body,                                                                                                   -- Skill (10) Consider replacing with Amalric Doublet +1 for +7 Conserve MP
        hands=gear.AF.hands,                                                                                                    -- Skill, DT
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}}, -- 6% Conserve MP
        feet={ name="Merlinic Crackows", augments={'"Fast Cast"+6','CHR+2','Mag. Acc.+8','"Mag.Atk.Bns."+11',}},                -- 4% Conserve MP
        neck={ name="Bagua Charm +1", augments={'Path: A',}},                                                                   -- Geomancy boost - Replace with Incanter's Torque when I have Idris + sufficient pet DT and regen for the MP effect.
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},                                                             -- 15% Conserve MP
        left_ear="Mendi. Earring",                                                                                              -- 2% Conserve MP
        right_ear={ name="Azimuth Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},                             -- Skill Consider replacing with Gwati Earring for Conserve
        left_ring="Stikini Ring",                                                                                               -- Skill
        right_ring="Stikini Ring",                                                                                              -- Skill
        back={ name="Lifestream Cape", augments={'Geomancy Skill +9','Indi. eff. dur. +20','Pet: Damage taken -2%',}},          -- Skill
    })

    sets.midcast.indicolure = set_combine(sets.idle[idle_mode.current], {                                                       -- 935 total at present
        main={ name="Gada", augments={'Indi. eff. dur. +10','Mag. Acc.+13','"Mag.Atk.Bns."+13','DMG:+10',}},                    -- Indi duration +10%
        sub="Genmei Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},                                              -- Skill
        ammo=empty,
        head=gear.empyrean.head,                                                                                                -- Skill, Set: MP occasionally not depleted when using geomancy spells.
        body=gear.relic.body,                                                                                                   -- Skill (10) Consider replacing with Amalric Doublet +1 for +7 Conserve MP
        hands=gear.AF.hands,                                                                                                    -- Skill, DT
        legs=gear.relic.legs,                                                                                                   -- Indi duration +12
        feet=gear.empyrean.feet,                                                                                                -- Indi duration +15, Set: MP occasionally not depleted when using geomancy spells.
        neck={ name="Bagua Charm +1", augments={'Path: A',}},                                                                   -- Geomancy boost - Replace with Incanter's Torque when I have Idris + sufficient pet DT and regen for the MP effect.
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},                                                             -- 15% Conserve MP
        left_ear="Mendi. Earring",                                                                                              -- 2% Conserve MP
        right_ear={ name="Azimuth Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},                             -- Skill Consider replacing with Gwati Earring for Conserve
        left_ring="Stikini Ring",                                                                                               -- Skill
        right_ring="Stikini Ring",                                                                                              -- Skill
        back={ name="Lifestream Cape", augments={'Geomancy Skill +9','Indi. eff. dur. +20','Pet: Damage taken -2%',}},          -- Skill
    })

    ----------------------------------------------------------------
    -- ENFEEBLING MIDCAST
    ----------------------------------------------------------------

    -- Geomancy Attire will be really good for this at +2 and +3
    -- Need the WHOLE set though lol, maybe minus the hands if I get the regal cuffs.
    -- Technically Cohort beats the Geo set by a tiny amount on skill+acc alone lol, but I guess more survivability via the geo set...? int? mnd? idk bwo
    sets.midcast["Enfeebling Magic"] = {
        main="Daybreak",
        sub="Ammurapi Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        ammo=empty,
        head=empty,
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet=gear.empyrean.feet,
        neck={ name="Bagua Charm +1", augments={'Path: A',}},
        waist="Rumination Sash",
        left_ear="Malignance Earring",
        right_ear={ name="Azimuth Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.midcast["Dispelga"] = set_combine(sets.midcast.enfeebling, {
        main="Daybreak",
        sub="Genmei Shield",
    })

    sets.midcast["Impact"] = {
        main="Daybreak",
        sub="Ammurapi Shield",
        range=empty,
        ammo="Kalboron Stone",
        body="Crepuscular Cloak",
        hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
        legs="Azimuth Tights +2",
        feet="Azimuth Gaiters +2",
        neck="Incanter's Torque",
        waist={ name="Acuity Belt +1", augments={'Path: A',}},
        left_ear="Malignance Earring",
        right_ear={ name="Azimuth Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},
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
        range=empty,
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
        back=gear.capes.enfeebling_healing_fc,
    })

    sets.midcast["Enhancing Magic"] = set_combine(sets.midcast["Free Nuke"], {                                                      -- +64% duration
        main={ name="Gada", augments={'Indi. eff. dur. +10','Mag. Acc.+13','"Mag.Atk.Bns."+13','DMG:+10',}},
        sub="Ammurapi Shield",                                                                                                      -- +10% duration
        range=empty,
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
        main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}},
        sub="Ammurapi Shield",
        --ammo="",
        head=gear.relic.head,
        body=gear.AF.body,
        --hands="",
        legs=gear.empyrean.legs,
        --feet="",
        neck="Dark Torque",
        waist="Fucho-no-Obi",
        left_ear="Barkaro. Earring",
        right_ear={ name="Azimuth Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},
        left_ring="Evanescence Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    })

    sets.midcast["Drain"] = sets.midcast["Aspir"]

    sets.midcast["Regen"] = set_combine(sets.midcast["Enhancing Magic"], {
        main="Bolelabunga",                                                                                                         -- 10% potency
    })

    ----------------------------------------------------------------
    -- IDLE SETS
    ----------------------------------------------------------------

    sets.idle["PDT"] = {                                                                                                                -- -40% DT, -39% PDT, -16% MDT (-75% DT+PDT, -51% DT+MDT)
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},                                    -- -0%
        sub="Genmei Shield",                                                                                                            -- -10% PDT
        range=empty,
        ammo="Staunch Tathlum",                                                                                                         -- -2% DT
        head=gear.empyrean.head,                                                                                                        -- -11% DT
        body=gear.AF.body,                                                                                                              -- +3 Refresh
        hands={ name="Hagondes Cuffs +1", augments={'Phys. dmg. taken -4%','Magic dmg. taken -3%','"Fast Cast"+4',}},                   -- -4% PDT, -3% MDT
        --legs={ name="Hagondes Pants +1", augments={'Phys. dmg. taken -4%','Magic dmg. taken -3%','"Avatar perpetuation cost" -4',}},  -- -4% PDT, -3% MDT
        legs="Assid. Pants +1",                                                                                                         -- +1-2 Refresh
        feet={ name="Hag. Sabots +1", augments={'Phys. dmg. taken -4%','Magic dmg. taken -4%','"Mag.Atk.Bns."+27',}},                   -- -4% PDT, -4% MDT
        neck="Loricate Torque +1",                                                                                                      -- -6% DT
        waist="Slipor Sash",                                                                                                            -- -3% MDT
        --left_ear="Etiolation Earring",                                                                                                -- -3% MDT I don't need more PDT here so I use Etiolation instead of Genmei
        left_ear="Alabaster Earring",                                                                                                   -- -5% DT
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},                                                                   -- -3% DT
        left_ring="Defending Ring",                                                                                                     -- -10% DT
        right_ring="Murky Ring",                                                                                                        -- -10% DT
        back=gear.capes.idle,                                                                                                           -- -10% PDT
    }

    -- Potentially make this a toggle
    sets.idle["MDT"] = set_combine(sets.idle["PDT"], {                                                                                  -- -34% DT, -29% PDT, -16% MDT (-63% DT+PDT, -50% DT+MDT)
        neck="Warder's Charm +1",
        back="Tuilha Cape",
    }) 

    -- Upgrade hands, then replace body with AF body for the refresh - upgrade AF body for more refresh. I will then be sitting at -37% Pet DT and +25 regen

    -- Bagua Feet - The Quest For A Bit More Idle Stats and Evasion And Stuff:
    -- Then replace feet with Bagua. This loses another Telchine to get me to -33% Pet DT and +22 regen. I then add the Bagua regen for -33% Pet DT and +27 regen.
    -- Not enough DT. I needle the cape back to before, I lose 5 regen and gain 5 Pet DT: -38% Pet DT and +22 regen.
    -- Not enough regen. I replace the Solstice (-4 Pet DT: -34% Pet DT and +22 regen.) with Sucellus (+3 Pet DT, +3 Regen: -37% Pet DT and +25 regen.)

    -- Consider Niburu Cudgel Path D or Sucellus
    sets.idle.luopan = {                                                                                                                -- -37% Pet DT (Capped at -37.5%), +25 Regen (need 24+), -27% DT, -17% PDT, -0% MDT (-44% DT+PDT, -27% DT+MDT)
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},                                    -- -4% Pet DT
        sub="Genmei Shield",                                                                                                            -- -10% PDT
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},                                                      -- -5% Pet DT
        ammo=empty,
        head={ name="Telchine Cap", augments={'Pet: "Regen"+3','Pet: Damage taken -4%',}},                                              -- -4% Pet DT, +3 Regen -- When I have Idris, replace with Azimuth head for DT
        body=gear.AF.body,                                                                                                              -- +3 Refresh -- Replace with Shamash when possible for DT
        hands=gear.AF.hands,                                                                                                            -- -3% DT, -13% Pet DT
        legs={ name="Telchine Braconi", augments={'Pet: "Regen"+3','Pet: Damage taken -4%',}},                                          -- -4% Pet DT, +3 Regen
        feet={ name="Telchine Pigaches", augments={'Pet: "Regen"+3','Pet: Damage taken -4%',}},                                         -- -4% Pet DT, +3 Regen
        neck="Loricate Torque +1",                                                                                                      -- -6% DT
        left_ear="Alabaster Earring",                                                                                                   -- -5% DT
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},                                                                   -- -3% DT
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},                                                                  -- -7% PDT
        right_ring="Murky Ring",                                                                                                        -- -10% DT
        waist="Isa Belt",                                                                                                               -- -3% Pet DT, +1 Regen
        back=gear.capes.luopan,                                                                                                         -- +15 regen
    }

    ----------------------------------------------------------------
    -- JOB ABILITIES
    ----------------------------------------------------------------

    sets.ja["Bolster"] = {
        body=gear.relic.body,
    }

    -- It's implied that I will already be in the Nantosuelta's Cape
    sets.ja["Life Cycle"] = {
        body=gear.AF.body,
    }

    sets.ja["Mending Halation"] = {
        legs=gear.relic.legs,
    }

    sets.ja["Radial Arcana"] = {
        feet=gear.relic.feet,
    }

    sets.ja["Full Circle"] = {
        head=gear.empyrean.head,
    }


    ----------------------------------------------------------------
    -- WEAPONSKILLS
    ----------------------------------------------------------------

    -- Just examples
    --sets.ws["Hexa Strike"] = {}
    --sets.ws["Realmrazer"] = {} -- This is apparently good?
end

----------------------------------------------------------------
-- LOGIC 
----------------------------------------------------------------

function precast(spell)
    if toggle_af_feet == "On" then
        add_to_chat(123, "Consider disabling the AF Feet toggle!")
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
    local match_list  = S{"Cure", "Aspir", "Drain", "Regen"}
    local matched = false

    -- If the spell matches one of the match_list spells.
    for match in match_list:it() do
        if spell.name:match(match) then
            equip(sets.midcast[match])
            matched = true
            break
        end
    end

    -- If the spell is a Geocolure or Indicolure spell
    if not matched then
        if spell.name:match("^Geo") then
            equip(sets.midcast.geocolure)
            matched = true
        elseif spell.name:match("^Indi") then
            equip(sets.midcast.indicolure)
            matched = true
        end
    end

    -- If the spell name EXACTLY matches.
    if not matched and sets.midcast[spell.name] then
        equip(sets.midcast[spell.name])
        matched = true
    end

    -- If the spell skill is Elemental Magic
    if not matched and spell.skill == "Elemental Magic" then
        equip(sets.midcast[nuking_mode.current])
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

    if S{"Elemental Magic","Healing Magic", "Dark Magic"}:contains(spell.skill) and S{world.weather_element, world.day_element}:contains(spell.element) then
        -- This will still trigger on stuff like Klimaform but eeh
        equip({waist="Hachirin-no-Obi"})

        -- Chatoyant staff check?
    end
end

-- Change checks to be "movement speed" stuff
function idle()
    if pet.isvalid then
        equip(sets.idle.luopan)
    else
        equip(sets.idle[idle_mode.current])
    end

    if toggle_af_feet == "On" then
        equip({feet=gear.AF.feet})
    end
end

function aftercast(spell)
    -- Gearswap will not immediately register the geocolure's summoning, so we skip this and wait for pet_change to handle the idle swap.
    if spell.name:match("^Geo") then
        return
    end

    idle()
end

function pet_change(pet,gain)
    -- We wait until here to select gear, as Gearswap doesn't immediately register the summoning in aftercast.
    if not midaction() then
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
    elseif main_command == "idlemode" then
        handle_mode(idle_mode_pairs, idle_mode, "Idle")

        if not pet.isvalid then
            idle()
        end
    elseif main_command == "toggleaffeet" then
        toggle_af_feet = (toggle_af_feet == "On") and "Off" or "On"
        idle()

        add_to_chat(123, "AF Feet toggle: " .. tostring(toggle_af_feet))
    elseif main_command == "toggletextbox" then
        text_box:visible(not text_box:visible())
    else
        add_to_chat(123, "Command not recognised.")
    end

    text_box:text("Nuke: " .. nuking_mode.current .. " | Idle: " .. idle_mode.current .. " | AF Feet: " .. toggle_af_feet)
end

function file_unload(file_name)
    send_command("unbind f1")
    send_command("unbind f2")

    send_command("unbind F5")
    send_command("unbind f6")

    send_command("unbind f9")
    send_command("unbind f12")
end