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
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local IconSize = Foundation.Enums.IconSize
local v20 = Roact.PureComponent:extend("SendInviteButton")

v20.validateProps = t.strictInterface({
	onActivated = t.callback,
	animationBegun = t.callback,
	animationEnded = t.callback,
	userInviteStatus = t.optional(t.string)
})

local function linearTween(p1, p2, p3) -- line: 47
	local v27 = (p3 - p2) / 30

	return (p1 - p2 / 30) / v27
end
local function isBetweenFrames(p4, p5, p6) -- line: 52
	return p4 >= p5 / 30 and p4 <= p6 / 30
end

local t1 = {
	[InviteStatus.Pending] = function(p7, p8) -- line: 57
		local v33 = math.sin(6.283185307179586 * p7) * 0.375 + 0.375

		p8.sendTransparency(v33)
	end,
	[InviteStatus.Success] = function(p9, p10, p11) -- line: 66
		if p9 >= 0 and p9 <= 0.13333333333333333 then
			local v37 = (p9 - 0) / 0.13333333333333333

			p10.sendTransparency(v37)
			p10.successTransparency(1 - v37)

			local v38 = 0.75 + 0.75 * (1 - v37)

			p10.successSize(v38)

			return
		end

		if p9 >= 0.13333333333333333 and p9 <= 0.3 then
			p10.sendTransparency(1)
			p10.successTransparency(0)

			local v39 = 0.75 + 0.25 * ((p9 - 0.13333333333333333) / 0.16666666666666666)

			p10.successSize(v39)

			return
		end

		p10.successSize(1)
		p11()
	end,
	[InviteStatus.Failed] = function(p12, p13, p14) -- line: 97
		if p12 >= 0 and p12 <= 0.06666666666666667 then
			local v43 = (p12 - 0) / 0.13333333333333333

			p13.sendTransparency(v43)
		elseif p12 >= 0.06666666666666667 and p12 <= 1.7333333333333334 then
			p13.sendTransparency(1)
		elseif p12 >= 1.7333333333333334 and p12 <= 1.9 then
			local v44 = (p12 - 1.7333333333333334) / 0.16666666666666666

			p13.sendTransparency(1 - v44)
		else
			p13.sendTransparency(0)
			p14()
		end

		if p12 >= 0 and p12 <= 0.13333333333333333 then
			local v45 = (p12 - 0) / 0.13333333333333333

			p13.failTransparency(1 - v45)

			return
		end

		if p12 >= 0.13333333333333333 and p12 <= 1.4 then
			p13.failTransparency(0)

			local v46 = p12 - 0.13333333333333333
			local v47 = -0.4 * 2.71828182846 ^ (-v46 * 8) * math.sin(v46 * 40)

			p13.failPos(v47)

			return
		end

		if p12 >= 1.4 and p12 <= 1.5666666666666667 then
			p13.failPos(0)

			local v48 = (p12 - 1.4) / 0.16666666666666666

			p13.failTransparency(v48)

			return
		end

		p13.failTransparency(1)
	end
}

function v20.init(p15, p16) -- line: 154
	-- upvalues: Roact (copy), InviteStatus (copy)
	local v51, v52 = Roact.createBinding(0)
	local v53, v54 = Roact.createBinding(1)
	local v55, v56 = Roact.createBinding(1)
	local v57, v58 = Roact.createBinding(1)
	local v59, v60 = Roact.createBinding(0)

	p15.bindings = {
		sendTransparency = v51,
		successTransparency = v53,
		failTransparency = v55,
		successSize = v57:map(function(p17) -- line: 166
			return UDim2.new(p17, 0, p17, 0)
		end),
		successScale = v57,
		failPos = v59:map(function(p18) -- line: 170
			return UDim2.new(p18, 0, 0, 0)
		end)
	}
	p15.updateBindings = {
		sendTransparency = v52,
		successTransparency = v54,
		failTransparency = v56,
		successSize = v58,
		failPos = v60
	}

	if p16.userInviteStatus == InviteStatus.Success then
		v54(0)
		v52(1)
	end
end
function v20.renderWithSelectionCursor(p19, p20) -- line: 189
	-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), v11 (copy), InviteStatus (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Icon (copy), IconName (copy), IconVariant (copy), IconSize (copy), ImageSetLabel (copy), Images (copy)
	local props = p19.props

	return withFoundationOrUIBloxStyle(function(p21) -- line: 192
		return {
			Theme = {
				IconEmphasis = {
					Color = p21.Color.Content.Emphasis.Color3,
					Transparency = p21.Color.Content.Emphasis.Transparency
				}
			},
			IconSize = p21.Size.Size_800
		}
	end, function(p22) -- line: 199
		-- upvalues: Roact (copy), p20 (copy), v11 (copy), props (copy), InviteStatus (copy), p19 (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Icon (copy), IconName (copy), IconVariant (copy), IconSize (copy), ImageSetLabel (copy), Images (copy)
		return Roact.createElement("TextButton", {
			Selectable = false,
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Text = "",
			SelectionImageObject = p20(v11.InputFields),
			[Roact.Event.Activated] = function() -- line: 207
				-- upvalues: props (copy), InviteStatus (copy), p19 (copy)
				local v77 = props.userInviteStatus == InviteStatus.Pending
				local v78 = props.userInviteStatus == InviteStatus.Success

				if not p19.renderSteppedConnection and (not v77 and not v78) then
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
			}) else Roact.createElement(Icon, {
				name = IconName.PersonArrowFromBottomRight,
				variant = IconVariant.Regular,
				size = IconSize.XXLarge,
				style = p19.bindings.sendTransparency:map(function(p23) -- line: 220
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
			}) else Roact.createElement(Icon, {
				name = IconName.CheckLarge,
				variant = IconVariant.Filled,
				size = p19.bindings.successScale:map(function(p24) -- line: 236
					-- upvalues: p22 (copy)
					return p22.IconSize * p24
				end),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				style = p19.bindings.successTransparency:map(function(p25) -- line: 241
					-- upvalues: p22 (copy)
					return {
						Color3 = p22.Theme.IconEmphasis.Color,
						Transparency = p25
					}
				end)
			}),
			FailLabel = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = Images["icons/status/alert"],
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = p22.Theme.IconEmphasis.Color,
				ImageTransparency = p19.bindings.failTransparency,
				Position = p19.bindings.failPos
			}) else Roact.createElement(Icon, {
				name = IconName.TriangleExclamation,
				variant = IconVariant.Filled,
				size = IconSize.XXLarge,
				style = p19.bindings.failTransparency:map(function(p26) -- line: 260
					-- upvalues: p22 (copy)
					return {
						Color3 = p22.Theme.IconEmphasis.Color,
						Transparency = p26
					}
				end),
				Position = p19.bindings.failPos
			})
		})
	end)
end
function v20.render(p27) -- line: 278
	-- upvalues: v10 (copy)
	return v10(function(p28) -- line: 279
		-- upvalues: p27 (copy)
		return p27:renderWithSelectionCursor(p28)
	end)
end
function v20.didUpdate(p29, p30) -- line: 284
	-- upvalues: t1 (copy)
	if p29.props.userInviteStatus and p29.props.userInviteStatus ~= p30.userInviteStatus then
		p29:playAnimation(t1[p29.props.userInviteStatus])
	end
end
function v20.didMount(p31) -- line: 290
	-- upvalues: t1 (copy)
	if p31.props.userInviteStatus then
		p31:playAnimation(t1[p31.props.userInviteStatus])
	end
end
function v20.playAnimation(p32, p33) -- line: 296
	-- upvalues: RunService (copy)
	p32.animationStartTime = tick()
	p32.animationFunction = p33

	if not p32.renderSteppedConnection then
		p32.renderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 301
			-- upvalues: p32 (copy)
			p32.animationFunction(tick() - p32.animationStartTime, p32.updateBindings, function() -- line: 302
				-- upvalues: p32 (copy)
				p32:stopAnimation()
			end)
		end)
		p32.props.animationBegun()
	end
end
function v20.stopAnimation(p34) -- line: 310
	if p34.renderSteppedConnection then
		p34.renderSteppedConnection:Disconnect()
		p34.renderSteppedConnection = nil
		p34.props.animationEnded()
	end
end
function v20.willUnmount(p35) -- line: 318
	p35:stopAnimation()
end

return v20
