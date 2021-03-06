if not GetNumGroupMembers then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Wind Lord Mel'jarak", 897, 741)
if not mod then return end
mod:RegisterEnableMob(62397, 62408, 62402, 62405) -- boss, mender, battlemaster, trapper

--------------------------------------------------------------------------------
-- Locales
--

local whirlingBlade, korthikStrike, rainOfBlades = (GetSpellInfo(121896)), (GetSpellInfo(122409)), (GetSpellInfo(122406))

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.next_pack = "Next pack"
	L.next_pack_desc = "Warning for when a new pack will land after you killed a pack."
	L.next_pack_icon = 125873

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{ 122064, "FLASHSHAKE", "SAY" },
		{ 122409, "ICON", "SAY" },
		122149,
		122406, { 121896, "SAY", "FLASHSHAKE", "ICON" }, { 131830, "SAY", "FLASHSHAKE" }, "next_pack",
		"proximity", "berserk", "bosskill",
	}, {
		[122064] = "ej:6300",
		[122409] = "ej:6334",
		[122149] = "ej:6305",
		[122406] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Resin", 122064)
	self:Log("SPELL_AURA_APPLIED", "NextPack", 125873)
	self:Log("SPELL_SUMMON", "WindBomb", 131814)
	self:Log("SPELL_CAST_START", "WhirlingBlade", 121896)
	self:Log("SPELL_CAST_START", "KorthikStrike", 122409)
	self:Log("SPELL_CAST_START", "Quickening", 122149)
	self:Log("SPELL_CAST_START", "RainOfBlades", 122406)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62397)
end

function mod:OnEngage(diff)
	self:Bar(121896, whirlingBlade, 36, 121896)
	self:Bar(122406, "~"..rainOfBlades, 60, 122406)
	self:OpenProximity(2) -- for amber prison EJ says 2 yards, but it might be bigger range
	self:Berserk(600) -- assume
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:RainOfBlades(_, _, _, _, spellName)
	self:Message(122406, spellName, "Important", 122406, "Alert")
	self:Bar(122406, "~"..spellName, 60, 122406)
end

function mod:Quickening(_, _, _, _, spellName)
	self:Message(122149, spellName, "Attention", 122149)
end

do
	local function checkTarget(sGUID)
		local mobId = mod:GetUnitIdByGUID(sGUID)
		if mobId then
			local player = UnitName(mobId.."target")
			if not player then return end
			if UnitIsUnit("player", player) then
				mod:Say(122409, CL["say"]:format(korthikStrike))
			end
			mod:TargetMessage(122409, korthikStrike, player, "Urgent", 122409, "Alarm")
			mod:SecondaryIcon(122409, player)
		end
	end
	function mod:KorthikStrike(...)
		local sGUID = select(11, ...)
		self:ScheduleTimer(checkTarget, 0.2, sGUID)
	end
end

do
	local function checkTarget(spellName)
		local player = UnitName("boss1target")
		if not player then return end
		if UnitIsUnit("player", player) then
			mod:Say(121896, CL["say"]:format(spellName))
			mod:FlashShake(121896)
		end
		mod:TargetMessage(121896, spellName, player, "Important", 121896, "Alert")
		mod:PrimaryIcon(121896, player)
	end

	function mod:WhirlingBlade(_, _, _, _, spellName)
		-- I know it is double message, but leave this here for debug purpose for now
		self:Message(121896, spellName, "Important", 121896, "Alert")
		self:Bar(121896, "~"..spellName, 45, 121896)
		self:ScheduleTimer(checkTarget, 0.2, spellName) -- might need to adjust this
	end
end

function mod:WindBomb(_, _, player, _, spellName)
	self:TargetMessage(131830, spellName, player, "Urgent", 131830, "Alarm")
	if UnitIsUnit("player", player) then
		self:FlashShake(131830)
		self:Say(131830, CL["say"]:format(spellName))
	end
end

function mod:NextPack()
	self:Bar("next_pack", L["next_pack"], 50, 125873)
	self:DelayedMessage("next_pack", 50, L["next_pack"], "Attention", 125873)
end

function mod:Resin(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:Say(122064, CL["say"]:format(spellName))
		self:FlashShake(122064)
		self:LocalMessage(122064, CL["you"]:format(spellName), "Personal", 122064, "Info")
	end
end

