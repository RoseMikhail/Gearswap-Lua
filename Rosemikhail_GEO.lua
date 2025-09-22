---@diagnostic disable: lowercase-global, undefined-global
include("Modes.lua")

nuking_mode = M{"Free Nuke", "Burst"}
idle_mode = M{"PDT", "MDT"} -- Maybe MDT can just be a toggle that puts on the specific bits

toggle_af_feet = "Off"

send_command("bind f1 gs c nukemode freenuke")
send_command("bind f2 gs c nukemode burst")

send_command("bind f5 gs c idlemode pdt")
send_command("bind f6 gs c idlemode mdt")

send_command("bind f9 gs c toggleaffeet")
send_command("bind f12 gs c toggletextbox")

add_to_chat(123, "F1-F2: Nuking modes, F5-F6: Idle modes")
add_to_chat(123, "F9: Toggle AF feet")
add_to_chat(123, "F12: Hide information text box")

-- Info Box
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
send_command("wait 3;input /lockstyleset 22") -- Geomancer Artifact

function update_macro_book()
    -- GEO/RDM macro book
    send_command("input /macro book 2;input /macro set 1")
end

update_macro_book()

-- Someday TODO: When I have Idris, I need a buff check for Entrust as Geomancy+ doesn't affect it. I will need to use my Gada +10% indocolore duration.
-- TODO: Someday I may want a Bagua Galero override for the HP+ 600 buff. Similar in style to my Mana Wall overrides. This would need to apply in all scenarios where gear changes. (pre/mid/after/pet_change/commands)
-- Potentially make an override to force the PDT idle set regardless of whether I have a bubble out.

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
        feet = "Geo. Sandals +2",
    }

    gear.relic = {
        head = "Bagua Galero",
        body = "Bagua Tunic",
        hands = "Bagua Mitaines",
        legs = { name="Bagua Pants +1", augments={'Enhances "Mending Halation" effect',}},
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

    sets.precast.fast_cast = {                                                                                                          -- OVERALL 87% FC, 9% Elem FC, 3% Occ
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},                                    -- 5% FC
        sub="Genmei Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},                                                      -- 3% FC
        head={ name="Merlinic Hood", augments={'"Fast Cast"+6','"Mag.Atk.Bns."+8',}},                                                   -- 14% FC
        body={ name="Merlinic Jubbah", augments={'Mag. Acc.+2','"Fast Cast"+7','INT+9','"Mag.Atk.Bns."+7',}},                           -- 13% FC
        hands="Mallquis Cuffs +2",                                                                                                      -- 6% Elem FC
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

    sets.precast["Dispelga"] = set_combine(sets.precast.fast_cast, {
        main="Daybreak",
        sub="Genmei Shield",
    })

    -- Maybe I can include Impact, but that seems silly.

    ----------------------------------------------------------------
    -- NUKE MIDCAST MODES
    ----------------------------------------------------------------

    -- Picking up more of the Ea set might make this better, but it isn't a priority.
    sets.midcast["Burst"] = {                                                                           -- 35% MB, 24% MB II
        main={ name="Marin Staff +1", augments={'Path: A',}},                                           -- Daybreak + Ammurapi will beat this in MACC and MAB
        sub="Enki Strap",
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

    sets.midcast["Free Nuke"] = {
        main={ name="Marin Staff +1", augments={'Path: A',}},                                           -- Daybreak + Ammurapi will beat this in MACC and MAB
        sub="Enki Strap",
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

    ----------------------------------------------------------------
    -- OTHER MIDCAST
    ----------------------------------------------------------------
    
    -- Can probably pull some of the skill gear out and replace with idle or conserve mp gear
    -- GEO SET CONSERVE MP: 43(GEO)+6+4+15+2 = 70%
    -- INDI SET CONSERVE MP: 43(GEO)+15+2 = 60%
    
    sets.midcast.geocolure = set_combine(sets.idle[idle_mode.current], {                                                        -- 920 total at present
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},                            -- Skill
        sub="Genmei Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},                                              -- Skill
        head=gear.empyrean.head,                                                                                                -- Skill, Set: MP occasionally not depleted when using geomancy spells.
        body=gear.relic.body,                                                                                                   -- Skill    Consider replacing with Amalric Double +1 for +7 Consere MP
        hands=gear.AF.hands,                                                                                                    -- Skill
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}}, -- 6% Conserve MP
        feet={ name="Merlinic Crackows", augments={'"Fast Cast"+6','CHR+2','Mag. Acc.+8','"Mag.Atk.Bns."+11',}},                -- 4% Conserve MP
        neck={ name="Bagua Charm +1", augments={'Path: A',}},                                                                   -- Geomancy boost - Replace with Incanter's Torque when I have Idris + sufficient pet DT and regen for the MP effect.
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},                                                             -- 15% Conserve MP
        left_ear="Mendi. Earring",                                                                                              -- 2% Conserve MP
        right_ear={ name="Azimuth Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},                             -- Skill
        left_ring="Stikini Ring",                                                                                               -- Skill
        right_ring="Stikini Ring",                                                                                              -- Skill
        back={ name="Lifestream Cape", augments={'Geomancy Skill +9','Indi. eff. dur. +20','Pet: Damage taken -2%',}},          -- Skill
    })

    sets.midcast.indicolure = set_combine(sets.idle[idle_mode.current], {                                                       -- 915 total at present
        main={ name="Gada", augments={'Indi. eff. dur. +10','Mag. Acc.+13','"Mag.Atk.Bns."+13','DMG:+10',}},                    -- Indi duration +10%
        sub="Genmei Shield",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},                                              -- Skill
        head=gear.empyrean.head,                                                                                                -- Skill, Set: MP occasionally not depleted when using geomancy spells.
        body=gear.relic.body,                                                                                                   -- Skill    Consider replacing with Amalric Double +1 for +7 Consere MP
        hands=gear.AF.hands,                                                                                                    -- Skill
        legs=gear.relic.legs,                                                                                                   -- Indi duration +12
        feet=gear.empyrean.feet,                                                                                                -- Indi duration +15, Set: MP occasionally not depleted when using geomancy spells.
        neck={ name="Bagua Charm +1", augments={'Path: A',}},                                                                   -- Geomancy boost - Replace with Incanter's Torque when I have Idris + sufficient pet DT and regen for the MP effect.
        waist={ name="Shinjutsu-no-Obi +1", augments={'Path: A',}},                                                             -- 15% Conserve MP
        left_ear="Mendi. Earring",                                                                                              -- 2% Conserve MP
        right_ear={ name="Azimuth Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},                             -- Skill
        left_ring="Stikini Ring",                                                                                               -- Skill
        right_ring="Stikini Ring",                                                                                              -- Skill
        back={ name="Lifestream Cape", augments={'Geomancy Skill +9','Indi. eff. dur. +20','Pet: Damage taken -2%',}},          -- Skill
    })

    -- Geomancy Attire will be really good for this at +2 and +3
    sets.midcast.enfeebling = {
        main={ name="Marin Staff +1", augments={'Path: A',}},                                           -- Daybreak + Ammurapi will beat this in MACC
        sub="Enki Strap",
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},
        head="",
        body={ name="Cohort Cloak +1", augments={'Path: A',}},
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet=gear.relic.feet,
        neck={ name="Bagua Charm +1", augments={'Path: A',}},
        waist="Rumination Sash",
        left_ear="Malignance Earring",
        right_ear={ name="Azimuth Earring", augments={'System: 1 ID: 1676 Val: 0','Mag. Acc.+9',}},
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Aurist's Cape +1", augments={'Path: A',}},
    }

    sets.midcast.dispelga = set_combine(sets.midcast.enfeebling, {
        main="Daybreak",
        sub="Genmei Shield",
    })

    sets.midcast.aspir = set_combine(sets.midcast["Free Nuke"], {
        main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}},
        sub="Genmei Shield",
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

    sets.midcast.enhancing = set_combine(sets.midcast["Free Nuke"], {                                                               -- +54% duration
        main={ name="Gada", augments={'Indi. eff. dur. +10','Mag. Acc.+13','"Mag.Atk.Bns."+13','DMG:+10',}},
        sub="Genmei Shield",
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

    sets.midcast.curing = set_combine(sets.midcast["Free Nuke"], {                                                                  -- Overall +50%
        main="Daybreak",                                                                                                            -- 30%
        sub="Genmei Shield",
        ammo="Kalboron Stone",
        head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},      -- +10%
        body={ name="Vanya Robe", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        hands={ name="Vanya Cuffs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        legs={ name="Vanya Slops", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
        feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},     -- Vanya +5%
        neck="Incanter's Torque",
        waist="Rumination Sash",
        left_ear="Mendi. Earring",
        right_ear="Lifestorm Earring",                                                                                              -- Mendicant's Earring +5%
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back=gear.capes.enfeebling_healing_fc,
    })

    -- Maybe I can include Impact, but that seems silly.

    ----------------------------------------------------------------
    -- IDLE SETS
    ----------------------------------------------------------------

    sets.idle["PDT"] = {                                                                                                                -- -32% DT, -39% PDT, -16% MDT (-71% DT+PDT, -48% DT+MDT)
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},                                    -- -0%
        sub="Genmei Shield",                                                                                                            -- -10% PDT
        ammo="Staunch Tathlum",                                                                                                         -- -2% DT
        head=gear.empyrean.head,                                                                                                        -- -11% DT
        --body="Mallquis Saio +2",                                                                                                        -- -8% DT
        body=gear.AF.body,                                                                                                              -- +3 Refresh, I think it's worth the uncapped MDT :p
        hands={ name="Hagondes Cuffs +1", augments={'Phys. dmg. taken -4%','Magic dmg. taken -3%','"Fast Cast"+4',}},                   -- -4% PDT, -3% MDT
        legs={ name="Hagondes Pants +1", augments={'Phys. dmg. taken -4%','Magic dmg. taken -3%','"Avatar perpetuation cost" -4',}},    -- -4% PDT, -3% MDT
        feet={ name="Hag. Sabots +1", augments={'Phys. dmg. taken -4%','Magic dmg. taken -4%','"Mag.Atk.Bns."+27',}},                   -- -4% PDT, -4% MDT
        neck="Loricate Torque +1",                                                                                                      -- -6% DT
        waist="Slipor Sash",                                                                                                            -- -3% MDT
        left_ear="Etiolation Earring",                                                                                                  -- -3% MDT I don't need more PDT here so I use Etiolation instead of Genmei
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},                                                                   -- -3% DT
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},                                                                  -- -7% PDT
        right_ring="Defending Ring",                                                                                                    -- -10% DT
        back=gear.capes.idle,                                                                                                           -- -10% PDT
    }

    -- Potentially make this a toggle
    sets.idle["MDT"] = set_combine(sets.idle["PDT"], {                                                                                  -- -23% DT, -33% PDT, -19% MDT (-66% DT+PDT, -42% DT+MDT)
        neck="Warder's Charm +1",
        --back="Tuilha Cape",
    }) 

    -- Upgrade hands, then replace body with AF body for the refresh - upgrade AF body for more refresh. I will then be sitting at -37% Pet DT and +25 regen

    -- Bagua Feet - The Quest For A Bit More Idle Stats and Evasion And Stuff:
    -- Then replace feet with Bagua. This loses another Telchine to get me to -33% Pet DT and +22 regen. I then add the Bagua regen for -33% Pet DT and +27 regen.
    -- Not enough DT. I needle the cape back to before, I lose 5 regen and gain 5 Pet DT: -38% Pet DT and +22 regen.
    -- Not enough regen. I replace the Solstice (-4 Pet DT: -34% Pet DT and +22 regen.) with Sucellus (+3 Pet DT, +3 Regen: -37% Pet DT and +25 regen.)

    -- Consider Niburu Cudgel Path D or Sucellus
    sets.idle.luopan = set_combine(sets.idle[idle_mode.current], {                                                                      -- -37% Pet DT (Capped at -37.5%), +25 Regen (need 24+), -21% DT, -20% PDT, -0% MDT (-41% DT+PDT, -18% DT+MDT)
        main={ name="Solstice", augments={'Mag. Acc.+20','Pet: Damage taken -4%','"Fast Cast"+5',}},                                    -- -4% Pet DT
        sub="Genmei Shield",                                                                                                            -- -10% PDT
        range={ name="Dunna", augments={'MP+20','Mag. Acc.+10','"Fast Cast"+3',}},                                                      -- -5% Pet DT
        ammo="",
        head={ name="Telchine Cap", augments={'Pet: "Regen"+3','Pet: Damage taken -4%',}},                                              -- -4% Pet DT, +3 Regen -- When I have Idris, replace with Azimuth head for DT
        body=gear.AF.body,                                                                                                              -- +3 Refresh -- Replace with Shamash when possible for DT
        hands=gear.AF.hands,                                                                                                            -- -3% DT, -13% Pet DT
        legs={ name="Telchine Braconi", augments={'Pet: "Regen"+3','Pet: Damage taken -4%',}},                                          -- -4% Pet DT, +3 Regen
        feet={ name="Telchine Pigaches", augments={'Pet: "Regen"+3','Pet: Damage taken -4%',}},                                         -- -4% Pet DT, +3 Regen
        neck="Loricate Torque +1",                                                                                                      -- -6% DT
        left_ear="Genmei Earring",                                                                                                      -- -2% PDT -- Likely replace with Etiolation or Ran earring when PDT/DT are maxed.
        right_ear={ name="Odnowa Earring +1", augments={'Path: A',}},                                                                   -- -3% DT
        left_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},                                                                  -- -7% PDT
        right_ring="Defending Ring",                                                                                                    -- -10% DT
        waist="Isa Belt",                                                                                                               -- -3% Pet DT, +1 Regen
        back=gear.capes.luopan,                                                                                                         -- +15 regen
    })

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
    if spell.name:match("Cure") then
        equip(sets.midcast.curing)
    elseif spell.name:match("Aspir") then
        equip(sets.midcast.aspir)
    elseif spell.name:match("^Geo") then
        equip(sets.midcast.geocolure)
    elseif spell.name:match("^Indi") then
        equip(sets.midcast.indicolure)
    elseif spell.name == "Dispelga" then
        equip(sets.midcast.dispelga)
    elseif spell.skill == "Enhancing Magic" then
        equip(sets.midcast.enhancing)
    elseif spell.skill == "Enfeebling Magic" then
        equip(sets.midcast.enfeebling)
    elseif spell.skill == "Elemental Magic" then
        local current_mode = sets.midcast[nuking_mode.current]
        if current_mode then
            equip(current_mode)
        else
            add_to_chat(123, "Invalid nuking mode: " .. nuking_mode.current)
        end
    elseif spell.action_type == "Magic" then
        -- Non-Cure Healing/unhandled Dark Magic/Divine Magic/Trusts would make their way here.
        --equip(sets.midcast["Free Nuke"])
        idle()
    end

    if S{"Elemental Magic","Healing Magic", "Dark Magic"}:contains(spell.skill) and S{world.weather_element, world.day_element}:contains(spell.element) then
        -- This will still trigger on stuff like Klimaform but eeh
        equip({waist="Hachirin-no-Obi"})
    end
end

function idle()
    if pet.isvalid and pet.name == "Luopan" then
        equip(sets.idle.luopan)

        if toggle_af_feet == "On" then
            equip({feet=gear.AF.feet})
        end
        return
    end

    -- Sanity check
    if sets.idle[idle_mode.current] then
        equip(sets.idle[idle_mode.current])
    else
        add_to_chat(123, "Invalid idle set: " .. idle_mode.current)
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

    -- Gearswap will not immediately register the geocolure's unsummoning, so we switch directly to our current idle mode.
    -- TODO: This is maybe unnecessary, as pet_change DOES handle switching back, just a little delayed.
    if S{"Full Circle", "Mending Halation", "Radial Arcana", "Concentric Pulse"}:contains(spell.name) then
        if sets.idle[idle_mode.current] then
            equip(sets.idle[idle_mode.current])
        else
            add_to_chat(123, "Invalid idle set: " .. idle_mode.current)
        end

        if toggle_af_feet == "On" then
            equip({feet=gear.AF.feet})
        end

        return
    end

    idle()
end

function pet_change(pet,gain)
    -- We switch to the luopan idle set here on the initial summon instead of via the aftercast, as gearswap does not immediately register the summoning.
    -- Upon losing our luopan in a way that is out of our control (i.e. damage or timeout), we will switch to a normal idle set.
    if pet.name == "Luopan" then
        if gain == true then
            equip(sets.idle.luopan)
        elseif gain == false then
            if not midaction() then
                -- Sanity check
                if sets.idle[idle_mode.current] then
                    equip(sets.idle[idle_mode.current])
                else
                    add_to_chat(123, "Invalid idle set: " .. idle_mode.current)
                end
            end
        end

        if toggle_af_feet == "On" then
            equip({feet=gear.AF.feet})
        end
    end
end

function status_change(new, old)
    idle()
end

function buff_change(name, gain, buff_details)
    -- Maybe add the currently active colures to the bar.
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
            else
                add_to_chat(123, "Argument not recognized.")
                return
            end

            add_to_chat(123, "Switching Idle mode to " .. idle_mode.current)

            -- Luopan
            if pet.isvalid and pet.name == "Luopan" then
                add_to_chat(123, "Idle gear will not switch due to your luopan currently being summoned.")
            else
                -- Sanity check
                if sets.idle[idle_mode.current] then
                    equip(sets.idle[idle_mode.current])
                else
                    add_to_chat(123, "Invalid idle set: " .. idle_mode.current)
                end

                if toggle_af_feet == "On" then
                    equip({feet=gear.AF.feet})
                end
            end
        else
            add_to_chat(123, "Missing argument.")
        end
    elseif commandArgs[1]:lower() == "toggleaffeet" then
        if toggle_af_feet == "On" then
            toggle_af_feet = "Off"
            idle()
        elseif toggle_af_feet == "Off" then
            toggle_af_feet = "On"
            equip({feet=gear.AF.feet})
        end

        add_to_chat(123, "AF Feet toggle: " .. tostring(toggle_af_feet))
    elseif commandArgs[1]:lower() == "toggletextbox" then
        if text_box:visible() == true then
            text_box:visible(false)
        else
            text_box:visible(true)
        end
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