--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Cho'gall", 758, 167)
if not mod then return end
mod:RegisterEnableMob(43324)

--------------------------------------------------------------------------------
-- Locals
--

local worshipTargets = mod:NewTargetList()
local worshipCooldown = 24
local firstFury = 0
local counter = 1
local corruptingCrash = GetSpellInfo(81685)
local bigcount = 1
local oozecount = 1
local oozeSpawn = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.alt_energy_title = "Corrupted Blood"

	L.orders = "Stance changes"
	L.orders_desc = "Warning for when Cho'gall changes between Shadow/Flame Orders stances."

	L.worship_cooldown = "~Worship"

	L.adherent_bar = "Big add #%d"
	L.adherent_message = "Add %d incoming!"
	L.ooze_bar = "Ooze swarm %d"
	L.ooze_message = "Ooze swarm %d incoming!"

	L.tentacles_bar = "Tentacles spawn"
	L.tentacles_message = "Tentacle disco party!"

	L.sickness_message = "You feel terrible!"
	L.blaze_message = "Fire under YOU!"
	L.crash_say = "Crash on ME!"

	L.fury_message = "Fury!"
	L.first_fury_soon = "Fury Soon!"
	L.first_fury_message = "85% - Fury Begins!"

	L.unleashed_shadows = "Pulsing Shadow"

	L.phase2_message = "Phase 2!"
	L.phase2_soon = "Phase 2 soon!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		91303, {81538, "FLASHSHAKE"}, {81685, "FLASHSHAKE", "ICON", "SAY"}, 81571, 82524, 81628, 82299,
		82630, 82414,
		"orders", {82235, "FLASHSHAKE", "PROXIMITY"}, "altpower", "berserk", "bosskill"
	}, {
		[91303] = CL.phase:format(1),
		[82630] = CL.phase:format(2),
		orders = "general"
	}
end

function mod:OnBossEnable()
	--normal
	self:Log("SPELL_CAST_SUCCESS", "Orders", 81171, 81556)
	self:Log("SPELL_AURA_APPLIED", "Worship", 91317, 93365, 93366, 93367)
	self:Log("SPELL_CAST_START", "SummonCorruptingAdherent", 81628) --does not happen on FM
	self:Log("SPELL_CAST_START", "FuryOfChogall", 82524)
	self:Log("SPELL_CAST_START", "FesterBlood", 82299)
	self:Log("SPELL_CAST_SUCCESS", "LastPhase", 82630)
	self:Log("SPELL_CAST_SUCCESS", "DarkenedCreations", 82414, 93160, 93162)
	self:Log("SPELL_CAST_SUCCESS", "CorruptingCrash", 81685, 93178, 93179, 93180)
	self:Log("SPELL_DAMAGE", "Blaze", 81538, 93212, 93213, 93214)

	self:Log("SPELL_AURA_APPLIED", "BigAddDeath", 81757)--10HM Spell
	self:Log("PARTY_KILL", "OrdersDeath","*")
	
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 43324)
end

function mod:OnEngage(diff)
	bigcount = 1
	oozecount = 1
	self:Bar(91303, L["worship_cooldown"], 10, 91303)
	self:Bar(81628, L["adherent_bar"]:format(bigcount), 65, 81628)--1:05 after pull.
	self:Bar(82299, L["ooze_bar"]:format(oozecount), 105, 82299)--1:45 after pull.
	oozeSpawn = GetTime() + 105
	self:Berserk(600-30)
	worshipCooldown = 40--24 FM? -- its not 40 sec till the 1st add
	firstFury = 0
	counter = 1

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	
	self:OpenAltPower(L["alt_energy_title"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BigAddDeath()
	bigcount = bigcount + 1
	--ADD:
	--#1 @ 8,52 - 68 = 1,08
	--#2 @ 7,05 - 107 = 1,47 <- maybe 7,07
	--#3 @ 5,22 - 103 = 1,43
	--ADD DEATH:
	--#1 @ 8,17 -> nextspawn: 72
	--#2 @ 6,36 -> nextspawn: 74
	--#3 @ 4,49
	self:Bar(81628, L["adherent_bar"]:format(bigcount), 73, 81628)
	local time = GetTime()
	if time > oozeSpawn then
		-- if we passed the oozespawn - can probably only happen on first BigAdd
		--DO NOT INCREMENT - it did not happen!
		self:Bar(82299, L["ooze_bar"]:format(oozecount), 105, 82299)
		oozeSpawn = GetTime() + 105
	end
end

do
	local last = 0
	function mod:Blaze(player, spellId, _, _, spellName)
		if UnitIsUnit(player, "player") then
			local time = GetTime()
			if (time - last) > 2 then
				last = time
				self:LocalMessage(81538, L["blaze_message"], "Personal", spellId, "Info")
				self:FlashShake(81538)
			end
		end
	end
end

do
	local last = 0
	function mod:CorruptingCrash(...)
		local time = GetTime()
		if (last-time) > 2 then
			last = time
			self:LocalMessage(81685, corruptingCrash, "Urgent", 81685, "Long")
		end
	end
end

do
	local sickness = GetSpellInfo(82235)
	local prev = 0
	function mod:UNIT_AURA(_, unit)
		if unit ~= "player" then return end
		local t = GetTime()
		if (t - prev) > 7 then
			local sick = UnitDebuff("player", sickness)
			if sick then
				prev = t
				self:LocalMessage(82235, L["sickness_message"], "Personal", 81831, "Long")
				self:OpenProximity(5, 82235)
				self:FlashShake(82235)
			end
		end
	end
end

function mod:FuryOfChogall(_, spellId, _, _, spellName)
	if firstFury == 1 then
		self:Message(82524, L["first_fury_message"], "Attention", spellId)
		--self:Bar(91303, L["worship_cooldown"], 10, 91303)
		--worshipCooldown = 40 --maybe 40secs is correct without 
		firstFury = 2
	else
		self:Message(82524, L["fury_message"], "Attention", spellId)
	end
	self:Bar(82524, spellName, 50, spellId)
end

function mod:Orders(_, spellId, _, _, spellName)
	self:Message("orders", spellName, "Urgent", spellId)
	if spellId == 81556 then --Shadow Order
		self:Bar("orders", GetSpellInfo(81556), 53, 81556)
	else
		self:Bar("orders", GetSpellInfo(81171), 53, 81171)
	end
end

function mod:OrdersDeath(mobID)
	--(43592, 43406)--Shadowlord, FireElemental
	if mobID == 43592 then --shadowlord
		self:Bar("orders", GetSpellInfo(81171), 16, 81171)
	else
		self:Bar("orders", GetSpellInfo(81556), 16, 81556)
	end
end

do
	local function nextAdd(spellId)
		mod:Bar(81628, L["adherent_bar"]:format(bigcount), 50, spellId)
	end
	function mod:SummonCorruptingAdherent(_, spellId, _, _, spellName)
		self:Message(81628, L["adherent_message"]:format(bigcount), "Important", spellId)
		bigcount = bigcount + 1
		self:ScheduleTimer(nextAdd, 41, spellId)

		-- I assume its 40 sec from summon and the timer is not between two casts of Fester Blood
		self:Bar(82299, L["ooze_bar"]:format(oozecount), 40, 82299)
	end
end

function mod:FesterBlood(_, spellId, _, _, spellName)
	--SCHLEIME:
	--#1 @ 8,15 1:45
	--#2 @ 6,30 1,45
	--#3 @ 4,47 1,43
	self:Message(82299, L["ooze_message"]:format(oozecount), "Attention", spellId, "Alert")
	oozecount = oozecount + 1
	self:Bar(82299, L["ooze_bar"]:format(oozecount), 105, 82299)
	oozeSpawn = GetTime() + 105
end

function mod:UNIT_HEALTH_FREQUENT(_, unit)
	if unit ~= "boss1" then return end
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if firstFury == 0 and hp > 86 and hp < 94 then
		self:Message(82524, L["first_fury_soon"], "Attention", 82524)
		firstFury = 1
	elseif hp < 30 then
		self:Message(82630, L["phase2_soon"], "Attention", 82630, "Info")
		self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
	end
end

function mod:LastPhase(_, spellId)
	self:SendMessage("BigWigs_StopBar", self, L["adherent_bar"]:format(bigcount))
	self:SendMessage("BigWigs_StopBar", self, L["ooze_bar"]:format(oozecount))
	self:SendMessage("BigWigs_StopBar", self, L["worship_cooldown"])
	self:Message(82630, L["phase2_message"], "Positive", spellId)
	self:Bar(82414, L["tentacles_bar"], 6, 82414)
end

function mod:DarkenedCreations(_, spellId)
	self:Message(82414, L["tentacles_message"], "Urgent", spellId)
	self:Bar(82414, L["tentacles_bar"], 30, 82414)
end

do
	local scheduled = nil
	local function worshipWarn(spellName)
		mod:TargetMessage(91303, spellName, worshipTargets, "Important", 91303)
		mod:PlaySound(91303, "Alarm")
		scheduled = nil
	end
	function mod:Worship(player, spellId, _, _, spellName)
		worshipTargets[#worshipTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:Bar(91303, L["worship_cooldown"], worshipCooldown, 91303)
			self:ScheduleTimer(worshipWarn, 0.3, spellName)
		end
	end
end

