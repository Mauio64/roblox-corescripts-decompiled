local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ParentParent = script.Parent.Parent.Parent
local InviteStatus = require(ParentParent.Resources.Constants).InviteStatus
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v14 = Roact.PureComponent:extend("SendInviteButton")

v14.validateProps = t.strictInterface({
	onActivated = t.callback,
	animationBegun = t.callback,
	animationEnded = t.callback,
	userInviteStatus = t.optional(t.string)
})

local function linearTween(p1, p2, p3) -- line: 35
	local v21 = (p3 - p2) / 30

	return (p1 - p2 / 30) / v21
end
local function isBetweenFrames(p4, p5, p6) -- line: 40
	return p4 >= p5 / 30 and p4 <= p6 / 30
end

local t1 = {
	[InviteStatus.Pending] = function(p7, p8) -- line: 45
		local v27 = math.sin(6.283185307179586 * p7) * 0.375 + 0.375

		p8.sendTransparency(v27)
	end,
	[InviteStatus.Success] = function(p9, p10, p11) -- line: 54
		if p9 >= 0 and p9 <= 0.13333333333333333 then
			local v31 = (p9 - 0) / 0.13333333333333333

			p10.sendTransparency(v31)
			p10.successTransparency(1 - v31)

			local v32 = 0.75 + 0.75 * (1 - v31)

			p10.successSize(v32)

			return
		end

		if p9 >= 0.13333333333333333 and p9 <= 0.3 then
			p10.sendTransparency(1)
			p10.successTransparency(0)

			local v33 = 0.75 + 0.25 * ((p9 - 0.13333333333333333) / 0.16666666666666666)

			p10.successSize(v33)

			return
		end

		p10.successSize(1)
		p11()
	end,
	[InviteStatus.Failed] = function(p12, p13, p14) -- line: 85
		if p12 >= 0 and p12 <= 0.06666666666666667 then
			local v37 = (p12 - 0) / 0.13333333333333333

			p13.sendTransparency(v37)
		elseif p12 >= 0.06666666666666667 and p12 <= 1.7333333333333334 then
			p13.sendTransparency(1)
		elseif p12 >= 1.7333333333333334 and p12 <= 1.9 then
			local v38 = (p12 - 1.7333333333333334) / 0.16666666666666666

			p13.sendTransparency(1 - v38)
		else
			p13.sendTransparency(0)
			p14()
		end

		if p12 >= 0 and p12 <= 0.13333333333333333 then
			local v39 = (p12 - 0) / 0.13333333333333333

			p13.failTransparency(1 - v39)

			return
		end

		if p12 >= 0.13333333333333333 and p12 <= 1.4 then
			p13.failTransparency(0)

			local v40 = p12 - 0.13333333333333333
			local v41 = -0.4 * 2.71828182846 ^ (-v40 * 8) * math.sin(v40 * 40)

			p13.failPos(v41)

			return
		end

		if p12 >= 1.4 and p12 <= 1.5666666666666667 then
			p13.failPos(0)

			local v42 = (p12 - 1.4) / 0.16666666666666666

			p13.failTransparency(v42)

			return
		end

		p13.failTransparency(1)
	end
}

function v14.init(p15, p16) -- line: 142
	-- upvalues: Roact (copy), InviteStatus (copy)
	local v45, v46 = Roact.createBinding(0)
	local v47, v48 = Roact.createBinding(1)
	local v49, v50 = Roact.createBinding(1)
	local v51, v52 = Roact.createBinding(1)
	local v53, v54 = Roact.createBinding(0)

	p15.bindings = {
		sendTransparency = v45,
		successTransparency = v47,
		failTransparency = v49,
		successSize = v51:map(function(p17) -- line: 154
			return UDim2.new(p17, 0, p17, 0)
		end),
		failPos = v53:map(function(p18) -- line: 157
			return UDim2.new(p18, 0, 0, 0)
		end)
	}
	p15.updateBindings = {
		sendTransparency = v46,
		successTransparency = v48,
		failTransparency = v50,
		successSize = v52,
		failPos = v54
	}

	if p16.userInviteStatus == InviteStatus.Success then
		v48(0)
		v46(1)
	end
end
function v14.renderWithSelectionCursor(p19, p20) -- line: 176
	-- upvalues: withStyle (copy), Roact (copy), CursorKind (copy), InviteStatus (copy), ImageSetLabel (copy), Images (copy)
	local props = p19.props

	return withStyle(function(p21) -- line: 179
		-- upvalues: Roact (copy), p20 (copy), CursorKind (copy), props (copy), InviteStatus (copy), p19 (copy), ImageSetLabel (copy), Images (copy)
		return Roact.createElement("TextButton", {
			Selectable = false,
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Text = "",
			SelectionImageObject = p20(CursorKind.InputFields),
			[Roact.Event.Activated] = function() -- line: 187
				-- upvalues: props (copy), InviteStatus (copy), p19 (copy)
				local v70 = props.userInviteStatus == InviteStatus.Pending
				local v71 = props.userInviteStatus == InviteStatus.Success

				if not p19.renderSteppedConnection and (not v70 and not v71) then
					props.onActivated()
				end
			end
		}, {
			SendLabel = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = Images["icons/actions/friends/friendInvite"],
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = p21.Theme.IconEmphasis.Color,
				ImageTransparency = p19.bindings.sendTransparency
			}),
			SuccessLabel = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = Images["icons/status/success"],
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageColor3 = p21.Theme.IconEmphasis.Color,
				ImageTransparency = p19.bindings.successTransparency,
				Size = p19.bindings.successSize
			}),
			FailLabel = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = Images["icons/status/alert"],
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = p21.Theme.IconEmphasis.Color,
				ImageTransparency = p19.bindings.failTransparency,
				Position = p19.bindings.failPos
			})
		})
	end)
end
function v14.render(p22) -- line: 226
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p23) -- line: 227
		-- upvalues: p22 (copy)
		return p22:renderWithSelectionCursor(p23)
	end)
end
function v14.didUpdate(p24, p25) -- line: 232
	-- upvalues: t1 (copy)
	if p24.props.userInviteStatus and p24.props.userInviteStatus ~= p25.userInviteStatus then
		p24:playAnimation(t1[p24.props.userInviteStatus])
	end
end
function v14.didMount(p26) -- line: 238
	-- upvalues: t1 (copy)
	if p26.props.userInviteStatus then
		p26:playAnimation(t1[p26.props.userInviteStatus])
	end
end
function v14.playAnimation(p27, p28) -- line: 244
	-- upvalues: RunService (copy)
	p27.animationStartTime = tick()
	p27.animationFunction = p28

	if not p27.renderSteppedConnection then
		p27.renderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 249
			-- upvalues: p27 (copy)
			p27.animationFunction(tick() - p27.animationStartTime, p27.updateBindings, function() -- line: 250
				-- upvalues: p27 (copy)
				p27:stopAnimation()
			end)
		end)
		p27.props.animationBegun()
	end
end
function v14.stopAnimation(p29) -- line: 258
	if p29.renderSteppedConnection then
		p29.renderSteppedConnection:Disconnect()
		p29.renderSteppedConnection = nil
		p29.props.animationEnded()
	end
end
function v14.willUnmount(p30) -- line: 266
	p30:stopAnimation()
end

return v14
