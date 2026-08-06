local function getOpenChannelName(p1) -- line: 3
	local TextChannels = p1.TextChannels

	if TextChannels == nil then
		return nil
	end

	local targetTextChannel = TextChannels.targetTextChannel

	if targetTextChannel ~= nil and targetTextChannel.Name ~= nil then
		return targetTextChannel.Name
	end

	local selectedChannelName = TextChannels.selectedChannelName
	local ChannelTabs = p1.ChannelTabs

	if selectedChannelName ~= nil and ChannelTabs ~= nil and ChannelTabs.allChannelTabs[selectedChannelName] ~= nil then
		return selectedChannelName
	end

	if ChannelTabs ~= nil then
		return ChannelTabs.selectedTabName or "RBXGeneral"
	end

	return selectedChannelName
end
local function getMessageChannelName(p2, s1: string?) -- line: 28
	if s1 ~= nil then
	else
		if p2.TextChannel == nil then
			return nil
		end

		s1 = p2.TextChannel.Name
	end

	if s1 == "RBXSystem" then
		s1 = "RBXGeneral"
	end

	return s1
end
local function isMessageForOpenChannel(p3, p4, s2: string?) -- line: 45
	local TextChannels = p3.TextChannels
	local g19 = nil
	local v15

	if TextChannels == nil then
		v15 = nil
	else
		local targetTextChannel = TextChannels.targetTextChannel

		if targetTextChannel ~= nil and targetTextChannel.Name ~= nil then
			v15 = targetTextChannel.Name
		else
			local selectedChannelName = TextChannels.selectedChannelName
			local ChannelTabs = p3.ChannelTabs

			v15 = if selectedChannelName == nil or (ChannelTabs == nil or ChannelTabs.allChannelTabs[selectedChannelName] == nil) then if ChannelTabs == nil then selectedChannelName else ChannelTabs.selectedTabName or "RBXGeneral" else selectedChannelName
		end
	end

	if s2 ~= nil then
	else
		if p4.TextChannel == nil then
			s2 = nil
			g19 = true
		end

		if not g19 then
			s2 = p4.TextChannel.Name
		end
	end

	if not g19 then
		if s2 == "RBXSystem" then
			s2 = "RBXGeneral"
		end
	end

	g19 = false

	if v15 == nil or s2 == nil then
		return true
	end

	return s2 == v15
end

return isMessageForOpenChannel
