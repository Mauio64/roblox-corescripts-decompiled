local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v10 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v11 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local ParentParent = script.Parent.Parent.Parent
local InviteStatus = require(ParentParent.Resources.Constants).InviteStatus
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FoundationImage = Foundation.Image
local v17 = Roact.PureComponent:extend("SendInviteButton")

v17.validateProps = t.strictInterface({
	onActivated = t.callback,
	animationBegun = t.callback,
	animationEnded = t.callback,
	userInviteStatus = t.optional(t.string)
})

local function linearTween(p1, p2, p3) -- line: 44
	local v24 = (p3 - p2) / 30

	return (p1 - p2 / 30) / v24
end
local function isBetweenFrames(p4, p5, p6) -- line: 49
	return p4 >= p5 / 30 and p4 <= p6 / 30
end

local t1 = {
	[InviteStatus.Pending] = function(p7, p8) -- line: 54
		local v30 = math.sin(6.283185307179586 * p7) * 0.375 + 0.375

		p8.sendTransparency(v30)
	end,
	[InviteStatus.Success] = function(p9, p10, p11) -- line: 63
		if p9 >= 0 and p9 <= 0.13333333333333333 then
			local v34 = (p9 - 0) / 0.13333333333333333

			p10.sendTransparency(v34)
			p10.successTransparency(1 - v34)

			local v35 = 0.75 + 0.75 * (1 - v34)

			p10.successSize(v35)

			return
		end

		if p9 >= 0.13333333333333333 and p9 <= 0.3 then
			p10.sendTransparency(1)
			p10.successTransparency(0)

			local v36 = 0.75 + 0.25 * ((p9 - 0.13333333333333333) / 0.16666666666666666)

			p10.successSize(v36)

			return
		end

		p10.successSize(1)
		p11()
	end,
	[InviteStatus.Failed] = function(p12, p13, p14) -- line: 94
		if p12 >= 0 and p12 <= 0.06666666666666667 then
			local v40 = (p12 - 0) / 0.13333333333333333

			p13.sendTransparency(v40)
		elseif p12 >= 0.06666666666666667 and p12 <= 1.7333333333333334 then
			p13.sendTransparency(1)
		elseif p12 >= 1.7333333333333334 and p12 <= 1.9 then
			local v41 = (p12 - 1.7333333333333334) / 0.16666666666666666

			p13.sendTransparency(1 - v41)
		else
			p13.sendTransparency(0)
			p14()
		end

		if p12 >= 0 and p12 <= 0.13333333333333333 then
			local v42 = (p12 - 0) / 0.13333333333333333

			p13.failTransparency(1 - v42)

			return
		end

		if p12 >= 0.13333333333333333 and p12 <= 1.4 then
			p13.failTransparency(0)

			local v43 = p12 - 0.13333333333333333
			local v44 = -0.4 * 2.71828182846 ^ (-v43 * 8) * math.sin(v43 * 40)

			p13.failPos(v44)

			return
		end

		if p12 >= 1.4 and p12 <= 1.5666666666666667 then
			p13.failPos(0)

			local v45 = (p12 - 1.4) / 0.16666666666666666

			p13.failTransparency(v45)

			return
		end

		p13.failTransparency(1)
	end
}

function v17.init(p15, p16) -- line: 151
	-- upvalues: Roact (copy), InviteStatus (copy)
	local v48, v49 = Roact.createBinding(0)
	local v50, v51 = Roact.createBinding(1)
	local v52, v53 = Roact.createBinding(1)
	local v54, v55 = Roact.createBinding(1)
	local v56, v57 = Roact.createBinding(0)

	p15.bindings = {
		sendTransparency = v48,
		successTransparency = v50,
		failTransparency = v52,
		successSize = v54:map(function(p17) -- line: 163
			return UDim2.new(p17, 0, p17, 0)
		end),
		failPos = v56:map(function(p18) -- line: 166
			return UDim2.new(p18, 0, 0, 0)
		end)
	}
	p15.updateBindings = {
		sendTransparency = v49,
		successTransparency = v51,
		failTransparency = v53,
		successSize = v55,
		failPos = v57
	}

	if p16.userInviteStatus == InviteStatus.Success then
		v51(0)
		v49(1)
	end
end
function v17.renderWithSelectionCursor(p19, p20) -- line: 185
	-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), v11 (copy), InviteStatus (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), ImageSetLabel (copy), Images (copy)
	local props = p19.props

	return withFoundationOrUIBloxStyle(function(p21) -- line: 188
		return {
			Theme = {
				IconEmphasis = {
					Color = p21.Color.Content.Emphasis.Color3,
					Transparency = p21.Color.Content.Emphasis.Transparency
				}
			}
		}
	end, function(p22) -- line: 194
		-- upvalues: Roact (copy), p20 (copy), v11 (copy), props (copy), InviteStatus (copy), p19 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), FoundationImage (copy), ImageSetLabel (copy), Images (copy)
		return Roact.createElement("TextButton", {
			Selectable = false,
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Text = "",
			SelectionImageObject = p20(v11.InputFields),
			[Roact.Event.Activated] = function() -- line: 202
				-- upvalues: props (copy), InviteStatus (copy), p19 (copy)
				local v74 = props.userInviteStatus == InviteStatus.Pending
				local v75 = props.userInviteStatus == InviteStatus.Success

				if not p19.renderSteppedConnection and (not v74 and not v75) then
					props.onActivated()
				end
			end
		}, {
			SendLabel = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = Images["icons/actions/friends/friendInvite"],
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = p22.Theme.IconEmphasis.Color,
				ImageTransparency = p19.bindings.sendTransparency
			}) else Roact.createElement(FoundationImage, {
				Image = "icons/actions/friends/friendInvite",
				Size = UDim2.new(1, 0, 1, 0),
				imageStyle = p19.bindings.sendTransparency:map(function(p23) -- line: 214
					-- upvalues: p22 (copy)
					return {
						Color3 = p22.Theme.IconEmphasis.Color,
						Transparency = p23
					}
				end)
			}),
			SuccessLabel = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = Images["icons/status/success"],
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageColor3 = p22.Theme.IconEmphasis.Color,
				ImageTransparency = p19.bindings.successTransparency,
				Size = p19.bindings.successSize
			}) else Roact.createElement(FoundationImage, {
				Image = "icons/status/success",
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				imageStyle = p19.bindings.successTransparency:map(function(p24) -- line: 231
					-- upvalues: p22 (copy)
					return {
						Color3 = p22.Theme.IconEmphasis.Color,
						Transparency = p24
					}
				end),
				Size = p19.bindings.successSize
			}),
			FailLabel = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = Images["icons/status/alert"],
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = p22.Theme.IconEmphasis.Color,
				ImageTransparency = p19.bindings.failTransparency,
				Position = p19.bindings.failPos
			}) else Roact.createElement(FoundationImage, {
				Image = "icons/status/alert",
				Size = UDim2.new(1, 0, 1, 0),
				imageStyle = p19.bindings.failTransparency:map(function(p25) -- line: 250
					-- upvalues: p22 (copy)
					return {
						Color3 = p22.Theme.IconEmphasis.Color,
						Transparency = p25
					}
				end),
				Position = p19.bindings.failPos
			})
		})
	end)
end
function v17.render(p26) -- line: 268
	-- upvalues: v10 (copy)
	return v10(function(p27) -- line: 269
		-- upvalues: p26 (copy)
		return p26:renderWithSelectionCursor(p27)
	end)
end
function v17.didUpdate(p28, p29) -- line: 274
	-- upvalues: t1 (copy)
	if p28.props.userInviteStatus and p28.props.userInviteStatus ~= p29.userInviteStatus then
		p28:playAnimation(t1[p28.props.userInviteStatus])
	end
end
function v17.didMount(p30) -- line: 280
	-- upvalues: t1 (copy)
	if p30.props.userInviteStatus then
		p30:playAnimation(t1[p30.props.userInviteStatus])
	end
end
function v17.playAnimation(p31, p32) -- line: 286
	-- upvalues: RunService (copy)
	p31.animationStartTime = tick()
	p31.animationFunction = p32

	if not p31.renderSteppedConnection then
		p31.renderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 291
			-- upvalues: p31 (copy)
			p31.animationFunction(tick() - p31.animationStartTime, p31.updateBindings, function() -- line: 292
				-- upvalues: p31 (copy)
				p31:stopAnimation()
			end)
		end)
		p31.props.animationBegun()
	end
end
function v17.stopAnimation(p33) -- line: 300
	if p33.renderSteppedConnection then
		p33.renderSteppedConnection:Disconnect()
		p33.renderSteppedConnection = nil
		p33.props.animationEnded()
	end
end
function v17.willUnmount(p34) -- line: 308
	p34:stopAnimation()
end

return v17
