--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Magmaw", 754, 170)
if not mod then return end
mod:RegisterEnableMob(41570)

local phase = 1
local isHeadPhase = nil
local lavaSpew = "~"..GetSpellInfo(77690)
local pillarOfFlame = "~"..GetSpellInfo(78006)
local mangle = "~"..GetSpellInfo(89773)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	-- heroic
	L.fire = "Ignition (Fire)"
	L.fire_desc = "Warning for when you stand in a Skeletons Fire."
	L.fire_message = "Fire under YOU!"
	
	L.blazing = "Skeleton Adds"
	L.blazing_desc = "Summons Blazing Bone Construct."
	L.blazing_message = "Add incoming!"
	L.blazing_bar = "Skeleton"

	L.armageddon = "Armageddon"
	L.armageddon_desc = "Warn if Armageddon is cast during the head phase."

	L.phase2 = "Phase 2"
	L.phase2_desc = "Warn for Phase 2 transition and display range check."
	L.phase2_message = "Phase 2!"
	L.phase2_yell = "You may actually defeat my lava worm"

	-- normal
	L.slump = "Slump (Rodeo)"
	L.slump_desc = "Warn for when Magmaw slumps forward and exposes himself, allowing the riding rodeo to start."
	L.slump_bar = "Rodeo"
	L.slump_message = "Yeehaw, ride on!"
	L.slump_trigger = "%s slumps forward, exposing his pincers!"

	L.infection_message = "You are infected!"

	L.expose_trigger = "head"
	L.expose_message = "Head exposed!"

	L.spew_warning = "Lava Spew Soon!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"slump", 79011, 89773, 78006, {78941, "FLASHSHAKE", "WHISPER", "PROXIMITY"}, 77690,
		"blazing", {"fire", "FLASHSHAKE"}, "armageddon", {"phase2", "PROXIMITY"},
		"berserk", "bosskill"
	}, {
		slump = "normal",
		blazing = "heroic",
		bosskill = "general"
	}
end

function mod:OnBossEnable()
	--heroic
	self:Log("SPELL_DAMAGE", "Fire", 92197, 92198, 92191, 92192)--Fire itself & initial dmg on Skeleton spawn
	
	self:Log("SPELL_SUMMON", "BlazingInferno", 92154, 92190, 92191, 92192)
	self:Yell("Phase2", L["phase2_yell"])

	--normal
	self:Log("SPELL_AURA_APPLIED", "Infection", 94679, 78097, 78941, 91913, 94678)
	self:Log("SPELL_AURA_REMOVED", "InfectionRemoved", 94679, 78097, 78941, 91913, 94678)
	self:Log("SPELL_CAST_SUCCESS", "PillarOfFlame", 78006, 77971, 77970, 77973)
	self:Log("SPELL_CAST_SUCCESS", "Mangle", 89773, 91912, 94616, 94617)
	self:Log("SPELL_AURA_REMOVED", "MangleRemoved", 89773, 91912, 94616, 94617)
	self:Log("SPELL_CAST_SUCCESS", "LavaSpew", 77690, 91919, 91931, 91932)
	self:Log("SPELL_AURA_APPLIED", "Armageddon", 92177)
	self:Emote("Slump", L["slump_trigger"])
	self:Emote("Vulnerability", L["expose_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	
	--INSTANCE_ENCOUNTER_ENGAGE_UNIT does not work on Frostmourne for  this boss
	--I don't know how i should do it ...
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:CheckForEngage()
	
	self:Death("Win", 41570)
end

function mod:OnEngage(diff)
	if diff > 2 then
		self:Bar("blazing", L["blazing_bar"], 20, "SPELL_SHADOW_RAISEDEAD")
	end
	self:Berserk(600)
	self:Bar("slump", L["slump_bar"], 30, 36702)
	self:Bar(78006, GetSpellInfo(78006), 21, 78006) --Pillar of Flame
	self:Bar(77690, lavaSpew, 15, 77690)
	self:Bar(89773, mangle, 25, 89773)
	self:DelayedMessage(77690, 12, L["spew_warning"], "Attention")
	phase = 1
	isHeadPhase = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Armageddon(_, spellId, _, _, spellName)
	if not isHeadPhase then return end
	self:Message(79011, spellName, "Important", spellId, "Alarm")
	self:Bar(79011, spellName, 8, spellId)
end

do
	local last = 0 
	function mod:Fire(player, spellId)
		if not UnitIsUnit(player, "player") then return end
		local time = GetTime()
		if (time - last) > 2 then
			last = time
			self:LocalMessage("fire", L["fire_message"], "Personal", spellId, "Info")
			self:FlashShake("fire")
		end		
	end
end

do
	local function rebootTimers()
		isHeadPhase = nil
		mod:Bar(78006, pillarOfFlame, 13, 78006)
		mod:Bar(77690, lavaSpew, 13, 77690)
	end
	function mod:Vulnerability()
		isHeadPhase = true
		self:Message(79011, L["expose_message"], "Positive", 79011)
		self:Bar(79011, L["expose_message"], 35, 79011)
		self:Bar(89773, mangle, 65, 89773)
		self:Bar("slump", L["slump_bar"], 70, 36702)
		self:SendMessage("BigWigs_StopBar", self, pillarOfFlame)
		self:SendMessage("BigWigs_StopBar", self, lavaSpew)
		self:CancelDelayedMessage(L["spew_warning"])
		self:ScheduleTimer(rebootTimers, 35)
	end
end

do
	local prev = 0
	function mod:LavaSpew(_, spellId, _, _, spellName)
		local time = GetTime()
		if time - prev > 10 then
			prev = time
			self:Message(77690, spellName, "Important", spellId)
			self:Bar(77690, lavaSpew, 26, spellId)
			self:DelayedMessage(77690, 24, L["spew_warning"], "Attention")
		end
	end
end

function mod:BlazingInferno(_, spellId)
	self:Message("blazing", L["blazing_message"], "Urgent", "Interface\\Icons\\SPELL_SHADOW_RAISEDEAD", "Info")
	self:Bar("blazing", L["blazing_bar"], 20, "SPELL_SHADOW_RAISEDEAD")
end

function mod:Phase2()
	phase = 2
	self:Message("phase2", L["phase2_message"], "Attention", 92195)
	self:SendMessage("BigWigs_StopBar", self, L["blazing_bar"])
	self:OpenProximity(8, "phase2")
end

do
	local prev = 0
	function mod:PillarOfFlame(_, spellId, _, _, spellName)
		local time = GetTime()
		if time - prev > 10 then
			prev = time
			self:Message(78006, spellName, "Urgent", spellId, "Alert")
			self:Bar(78006, pillarOfFlame, 32, spellId)
		end
	end
end

function mod:Infection(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(78941, L["infection_message"], "Personal", spellId, "Alarm")
		self:FlashShake(78941)
		self:OpenProximity(8, 78941)
	else
		self:Whisper(78941, player, L["infection_message"], true)
	end
end

function mod:InfectionRemoved(player)
	if phase == 1 and UnitIsUnit(player, "player") then
		self:CloseProximity(78941)
	end
end

function mod:Slump()
	self:SendMessage("BigWigs_StopBar", self,  pillarOfFlame)
	self:Bar("slump", L["slump_bar"], 105, 36702)
	self:Message("slump", L["slump_message"], "Positive", 36702, "Info")
end

do
	function mod:Mangle(player, spellId, _, _, spellName)
		self:TargetMessage(89773, spellName, player, "Personal", spellId, "Info")
		self:Bar(89773, CL["other"]:format(spellName, player), 30, spellId)
		self:Bar(89773, mangle, 105, 89773)
	end

	function mod:MangleRemoved(player, _, _, _, spellName)
		self:SendMessage("BigWigs_StopBar", self, CL["other"]:format(spellName, player))
	end
end

