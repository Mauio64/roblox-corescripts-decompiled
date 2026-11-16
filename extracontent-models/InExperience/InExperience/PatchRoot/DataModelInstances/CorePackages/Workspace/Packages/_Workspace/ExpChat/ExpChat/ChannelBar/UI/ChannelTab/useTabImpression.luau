local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local ExpChatShared = require(parent.ExpChatShared)
local Cryo = require(parent.Cryo)

local FFlagGlobalTextChatAddPlaySessionField = require(ExpChat.Flags.FFlagGlobalTextChatAddPlaySessionField)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)

local Analytics = ExpChatShared.Analytics

local joined = Cryo.List.join(
	Analytics.DefaultStandardizedFields,
	{ "addPlaceInstanceId" },
	FFlagGlobalTextChatAddPlaySessionField and { "addPlaySessionId" } or {}
)

local function useTabImpression(data)
	local tabType = data.tabType or "Unknown"
	local badge_count = data.hasUnreadMessages and 1 or 0

	local useEffect = React.useEffect
	local function fn()
		if not data.enabled then
			return
		end

		local expChatTabImpressionConfig = Analytics.ExpChatTabImpressionConfig
		local v = {
			name = data.name,
			type = tabType,
			index = data.index,
			in_overflow = data.inOverflow,
			visible = data.visible,
			badge_count = badge_count,
			is_selected = 0
		}
		local is_selected

		if FFlagExpChatGlobalTabDefault then
			is_selected = data.isSelected == true
		end

		v.is_selected = is_selected
		Analytics:TelemetryLogEvent(expChatTabImpressionConfig, v, joined)
	end

	local enabled = data.enabled
	local name = data.name

	local index = data.index
	local inOverflow = data.inOverflow
	local visible = data.visible
	local v

	if FFlagExpChatGlobalTabDefault then
		v = data.isSelected
	end

	useEffect(fn, { enabled, name, tabType, index, inOverflow, visible, badge_count, v })
end

return useTabImpression
