local Parent = script:FindFirstAncestor("ExpChat").Parent
local v2 = require(Parent.ExpChatShared).Logger:new("ExpChat/" .. script.Name)
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UIBlox = require(Parent.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local BubbleChat = script:FindFirstAncestor("BubbleChat")
local getVoiceIndicatorIcon = require(BubbleChat.Helpers.getVoiceIndicatorIcon)
local Roact = require(Parent.Roact)
local RoactRodux = require(Parent.RoactRodux)
local GetFFlagExpChatUseVoiceParticipantsStore = require(Parent.SharedFlags).GetFFlagExpChatUseVoiceParticipantsStore
local v13 = Roact.PureComponent:extend("VoiceIndicator")

v13.defaultProps = {}

function v13.init(p1) -- line: 48
	-- upvalues: Roact (copy), HttpService (copy), RunService (copy), getVoiceIndicatorIcon (copy)
	local v16, v17 = Roact.createBinding(0)

	p1.level = v16
	p1.updateLevel = v17

	local v18, v19 = Roact.createBinding(p1.props.voiceState)

	p1.voiceState = v18
	p1.updateVoiceState = v19
	p1.renderStepName = HttpService:GenerateGUID()
	RunService:BindToRenderStep(p1.renderStepName, 1, function() -- line: 55
		-- upvalues: p1 (copy)
		p1.updateLevel(math.random())
	end)
	p1.levelIcon = Roact.joinBindings({
		p1.voiceState,
		p1.level
	}):map(function(t1: {[any]: any}) -- line: 59
		-- upvalues: getVoiceIndicatorIcon (copy), p1 (copy)
		local v33 = t1[1]
		local v34 = t1[2]

		return getVoiceIndicatorIcon(p1.props.getIcon, v33, v34, p1.props.iconStyle)
	end)

	function p1.onClicked() -- line: 66
		-- upvalues: p1 (copy)
		if p1.props.onClicked and p1.props.userId then
			p1.props.onClicked(p1.props.userId)
		end
	end
end
function v13.renderWithSelectionCursor(p2, p3) -- line: 73
	-- upvalues: Roact (copy), CursorKind (copy)
	local v22 = p2.props.voiceState == "Error" or p2.props.voiceState == "Hidden"

	if p2.props.hideOnError and (not p2.props.voiceState or v22) then
		return nil
	end

	local v23 = p2.props.voiceState ~= "LOCAL_MUTED" and 0 or 0.5

	if p2.props.iconTransparency then
		local v24 = v23

		v23 = if type(p2.props.iconTransparency) == "number" then 1 - (1 - p2.props.iconTransparency) * (1 - v24) else p2.props.iconTransparency:map(function(p4) -- line: 84
			-- upvalues: v24 (copy)
			return 1 - (1 - p4) * (1 - v24)
		end)
	end

	return Roact.createElement("ImageButton", {
		Size = p2.props.size or UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = p2.levelIcon,
		ImageTransparency = v23,
		SelectionImageObject = p3(CursorKind.RoundedRectNoInset),
		[Roact.Event.Activated] = p2.onClicked
	})
end
function v13.render(p5) -- line: 103
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p6) -- line: 104
		-- upvalues: p5 (copy)
		return p5:renderWithSelectionCursor(p6)
	end)
end
function v13.didUpdate(p7, p8, _) -- line: 109
	-- upvalues: v2 (copy)
	v2:trace("Voice state updated to {} for ...{}", p7.props.voiceState, (string.sub(tostring(p7.props.userId), -4)))

	if p8.voiceState ~= p7.props.voiceState then
		p7.updateVoiceState(p7.props.voiceState)
	end
end
function v13.willUnmount(p10) -- line: 121
	-- upvalues: RunService (copy)
	pcall(function() -- line: 122
		-- upvalues: RunService (copy), p10 (copy)
		RunService:UnbindFromRenderStep(p10.renderStepName)
	end)
end

local function mapStateToProps(p11, p12) -- line: 127
	return {
		voiceState = p11.Voice.participants[p12.userId]
	}
end

if GetFFlagExpChatUseVoiceParticipantsStore() then
	return v13
end

return RoactRodux.connect(mapStateToProps)(v13)
