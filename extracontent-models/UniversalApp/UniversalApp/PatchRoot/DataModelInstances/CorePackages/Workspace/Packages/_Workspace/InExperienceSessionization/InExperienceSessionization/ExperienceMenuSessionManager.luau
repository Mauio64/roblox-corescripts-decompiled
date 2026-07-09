local SessionType = require(script.Parent.SessionType)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 37
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	if p1 then
		self._sessionService = p1
	else
		self._sessionService = game:GetService("SessionService")
	end

	self._currentMenuTab = nil

	return self
end
function t1._setMetadata(t2: {[any]: any}, s1: string, s2: string, s3: string) -- line: 50
	t2._sessionService:SetMetadata(s1, s2, s3)
end
function t1.OpenExperienceMenu(t3: {[any]: any}, t4: {[any]: any}?) -- line: 54
	-- upvalues: SessionType (copy)
	t3._sessionService:SetSession(SessionType.StructuralIdentifier.Level2a, SessionType.StructuralIdentifier.ExperienceMenu, SessionType.Tag.level3.ExperienceMenu)

	if t4 then
		for k, v in pairs(t4) do
			t3._sessionService:SetMetadata(SessionType.StructuralIdentifier.ExperienceMenu, k, v)
		end
	end
end
function t1.CloseExperienceMenu(p2) -- line: 67
	-- upvalues: SessionType (copy)
	p2:CloseOpenedMenuTab()
	p2._sessionService:RemoveSession(SessionType.StructuralIdentifier.ExperienceMenu)
end
function t1.CloseOpenedMenuTab(p3) -- line: 72
	if p3._currentMenuTab then
		p3._sessionService:RemoveSession(p3._currentMenuTab)
		p3._currentMenuTab = nil
	end
end
function t1.OpenPeopleTab(t5: {[any]: any}, s4: string?, t6: {[any]: any}?) -- line: 79
	-- upvalues: SessionType (copy)
	local v18 = s4 or SessionType.StructuralIdentifier.ExperienceMenu

	t5._sessionService:SetSession(v18, SessionType.StructuralIdentifier.PeopleTab, SessionType.Tag.level3.PeopleTab)

	if t6 then
		for k, v in pairs(t6) do
			t5._sessionService:SetMetadata(SessionType.StructuralIdentifier.PeopleTab, k, v)
		end
	end

	t5._currentMenuTab = SessionType.StructuralIdentifier.PeopleTab
end
function t1.OpenSettingsTab(t7: {[any]: any}, s5: string?, t8: {[any]: any}?) -- line: 91
	-- upvalues: SessionType (copy)
	local v24 = s5 or SessionType.StructuralIdentifier.ExperienceMenu

	t7._sessionService:SetSession(v24, SessionType.StructuralIdentifier.SettingsTab, SessionType.Tag.level3.SettingsTab)

	if t8 then
		for k, v in pairs(t8) do
			t7._sessionService:SetMetadata(SessionType.StructuralIdentifier.SettingsTab, k, v)
		end
	end

	t7._currentMenuTab = SessionType.StructuralIdentifier.SettingsTab
end
function t1.OpenCapturesTab(t9: {[any]: any}, s6: string?, t10: {[any]: any}?) -- line: 107
	-- upvalues: SessionType (copy)
	local v30 = s6 or SessionType.StructuralIdentifier.ExperienceMenu

	t9._sessionService:SetSession(v30, SessionType.StructuralIdentifier.CapturesTab, SessionType.Tag.level3.CapturesTab)

	if t10 then
		for k, v in pairs(t10) do
			t9._sessionService:SetMetadata(SessionType.StructuralIdentifier.CapturesTab, k, v)
		end
	end

	t9._currentMenuTab = SessionType.StructuralIdentifier.CapturesTab
end
function t1.OpenReportTab(t11: {[any]: any}, s7: string?, t12: {[any]: any}?) -- line: 123
	-- upvalues: SessionType (copy)
	local v36 = s7 or SessionType.StructuralIdentifier.ExperienceMenu

	t11._sessionService:SetSession(v36, SessionType.StructuralIdentifier.ReportTab, SessionType.Tag.level3.ReportTab)

	if t12 then
		for k, v in pairs(t12) do
			t11._sessionService:SetMetadata(SessionType.StructuralIdentifier.ReportTab, k, v)
		end
	end

	t11._currentMenuTab = SessionType.StructuralIdentifier.ReportTab
end
function t1.OpenHelpTab(t13: {[any]: any}, s8: string?, t14: {[any]: any}?) -- line: 135
	-- upvalues: SessionType (copy)
	local v42 = s8 or SessionType.StructuralIdentifier.ExperienceMenu

	t13._sessionService:SetSession(v42, SessionType.StructuralIdentifier.HelpTab, SessionType.Tag.level3.HelpTab)

	if t14 then
		for k, v in pairs(t14) do
			t13._sessionService:SetMetadata(SessionType.StructuralIdentifier.HelpTab, k, v)
		end
	end

	t13._currentMenuTab = SessionType.StructuralIdentifier.HelpTab
end
function t1.OpenLeaveExperience(t15: {[any]: any}, s9: string?, t16: {[any]: any}?) -- line: 147
	-- upvalues: SessionType (copy)
	local v48 = s9 or SessionType.StructuralIdentifier.ExperienceMenu

	t15._sessionService:SetSession(v48, SessionType.StructuralIdentifier.LeaveExperience, SessionType.Tag.level3.LeaveExperience)

	if t16 then
		for k, v in pairs(t16) do
			t15._sessionService:SetMetadata(SessionType.StructuralIdentifier.LeaveExperience, k, v)
		end
	end

	t15._currentMenuTab = SessionType.StructuralIdentifier.LeaveExperience
end
function t1.OpenResetCharacter(t17: {[any]: any}, s10: string?, t18: {[any]: any}?) -- line: 163
	-- upvalues: SessionType (copy)
	local v54 = s10 or SessionType.StructuralIdentifier.ExperienceMenu

	t17._sessionService:SetSession(v54, SessionType.StructuralIdentifier.ResetCharacter, SessionType.Tag.level3.ResetCharacter)

	if t18 then
		for k, v in pairs(t18) do
			t17._sessionService:SetMetadata(SessionType.StructuralIdentifier.ResetCharacter, k, v)
		end
	end

	t17._currentMenuTab = SessionType.StructuralIdentifier.ResetCharacter
end
function t1.MenuSwitchToPage(p4, p5) -- line: 179
	if p5 == nil then
		return
	end

	p4:CloseOpenedMenuTab()

	local p5Name = p5.Name

	if p5Name == "Players" then
		p4:OpenPeopleTab()

		return
	end

	if p5Name == "Page" then
		p4:OpenSettingsTab()

		return
	end

	if p5Name == "Captures" then
		p4:OpenCapturesTab()

		return
	end

	if p5Name == "ReportAbuseMenuNewContainerPage" then
		p4:OpenReportTab()

		return
	end

	if p5Name == "Help" then
		p4:OpenHelpTab()

		return
	end

	if p5Name == "LeaveGamePage" then
		p4:OpenLeaveExperience()

		return
	end

	if p5Name == "ResetCharacter" then
		p4:OpenResetCharacter()
	end
end

return t1
