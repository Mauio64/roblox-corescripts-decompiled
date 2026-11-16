local SessionType = require(script.Parent.SessionType)

local ExperienceMenuSessionManager = {}
ExperienceMenuSessionManager.__index = ExperienceMenuSessionManager

function ExperienceMenuSessionManager.new(sessionService)
	local self = setmetatable({}, ExperienceMenuSessionManager)

	if sessionService then
		self._sessionService = sessionService
	else
		self._sessionService = game:GetService("SessionService")
	end

	self._currentMenuTab = nil

	return self
end

function ExperienceMenuSessionManager:_setMetadata(p: string, p2: string, p3: string)
	self._sessionService:SetMetadata(p, p2, p3)
end

function ExperienceMenuSessionManager:OpenExperienceMenu(items)
	self._sessionService:SetSession(
		SessionType.StructuralIdentifier.Level2a,
		SessionType.StructuralIdentifier.ExperienceMenu,
		SessionType.Tag.level3.ExperienceMenu
	)

	if items then
		for k, item in pairs(items) do
			self._sessionService:SetMetadata(SessionType.StructuralIdentifier.ExperienceMenu, k, item)
		end
	end
end

function ExperienceMenuSessionManager:CloseExperienceMenu()
	self:CloseOpenedMenuTab()
	self._sessionService:RemoveSession(SessionType.StructuralIdentifier.ExperienceMenu)
end

function ExperienceMenuSessionManager:CloseOpenedMenuTab()
	if self._currentMenuTab then
		self._sessionService:RemoveSession(self._currentMenuTab)
		self._currentMenuTab = nil
	end
end

function ExperienceMenuSessionManager:OpenPeopleTab(p: string?, items)
	local v = p or SessionType.StructuralIdentifier.ExperienceMenu
	self._sessionService:SetSession(v, SessionType.StructuralIdentifier.PeopleTab, SessionType.Tag.level3.PeopleTab)

	if items then
		for k, item in pairs(items) do
			self._sessionService:SetMetadata(SessionType.StructuralIdentifier.PeopleTab, k, item)
		end
	end

	self._currentMenuTab = SessionType.StructuralIdentifier.PeopleTab
end

function ExperienceMenuSessionManager:OpenSettingsTab(p: string?, items)
	local v = p or SessionType.StructuralIdentifier.ExperienceMenu
	self._sessionService:SetSession(v, SessionType.StructuralIdentifier.SettingsTab, SessionType.Tag.level3.SettingsTab)

	if items then
		for k, item in pairs(items) do
			self._sessionService:SetMetadata(SessionType.StructuralIdentifier.SettingsTab, k, item)
		end
	end

	self._currentMenuTab = SessionType.StructuralIdentifier.SettingsTab
end

function ExperienceMenuSessionManager:OpenCapturesTab(p: string?, items)
	local v = p or SessionType.StructuralIdentifier.ExperienceMenu
	self._sessionService:SetSession(v, SessionType.StructuralIdentifier.CapturesTab, SessionType.Tag.level3.CapturesTab)

	if items then
		for k, item in pairs(items) do
			self._sessionService:SetMetadata(SessionType.StructuralIdentifier.CapturesTab, k, item)
		end
	end

	self._currentMenuTab = SessionType.StructuralIdentifier.CapturesTab
end

function ExperienceMenuSessionManager:OpenReportTab(p: string?, items)
	local v = p or SessionType.StructuralIdentifier.ExperienceMenu
	self._sessionService:SetSession(v, SessionType.StructuralIdentifier.ReportTab, SessionType.Tag.level3.ReportTab)

	if items then
		for k, item in pairs(items) do
			self._sessionService:SetMetadata(SessionType.StructuralIdentifier.ReportTab, k, item)
		end
	end

	self._currentMenuTab = SessionType.StructuralIdentifier.ReportTab
end

function ExperienceMenuSessionManager:OpenHelpTab(p: string?, items)
	local v = p or SessionType.StructuralIdentifier.ExperienceMenu
	self._sessionService:SetSession(v, SessionType.StructuralIdentifier.HelpTab, SessionType.Tag.level3.HelpTab)

	if items then
		for k, item in pairs(items) do
			self._sessionService:SetMetadata(SessionType.StructuralIdentifier.HelpTab, k, item)
		end
	end

	self._currentMenuTab = SessionType.StructuralIdentifier.HelpTab
end

function ExperienceMenuSessionManager:OpenLeaveExperience(p: string?, items)
	local v = p or SessionType.StructuralIdentifier.ExperienceMenu
	self._sessionService:SetSession(
		v,
		SessionType.StructuralIdentifier.LeaveExperience,
		SessionType.Tag.level3.LeaveExperience
	)

	if items then
		for k, item in pairs(items) do
			self._sessionService:SetMetadata(SessionType.StructuralIdentifier.LeaveExperience, k, item)
		end
	end

	self._currentMenuTab = SessionType.StructuralIdentifier.LeaveExperience
end

function ExperienceMenuSessionManager:OpenResetCharacter(p: string?, items)
	local v = p or SessionType.StructuralIdentifier.ExperienceMenu
	self._sessionService:SetSession(
		v,
		SessionType.StructuralIdentifier.ResetCharacter,
		SessionType.Tag.level3.ResetCharacter
	)

	if items then
		for k, item in pairs(items) do
			self._sessionService:SetMetadata(SessionType.StructuralIdentifier.ResetCharacter, k, item)
		end
	end

	self._currentMenuTab = SessionType.StructuralIdentifier.ResetCharacter
end

function ExperienceMenuSessionManager:MenuSwitchToPage(p)
	if p == nil then
		return
	end

	self:CloseOpenedMenuTab()
	local name = p.Name

	if name == "Players" then
		self:OpenPeopleTab()
	elseif name == "Page" then
		self:OpenSettingsTab()
	elseif name == "Captures" then
		self:OpenCapturesTab()
	elseif name == "ReportAbuseMenuNewContainerPage" then
		self:OpenReportTab()
	elseif name == "Help" then
		self:OpenHelpTab()
	elseif name == "LeaveGamePage" then
		self:OpenLeaveExperience()
	elseif name == "ResetCharacter" then
		self:OpenResetCharacter()
	end
end

return ExperienceMenuSessionManager
