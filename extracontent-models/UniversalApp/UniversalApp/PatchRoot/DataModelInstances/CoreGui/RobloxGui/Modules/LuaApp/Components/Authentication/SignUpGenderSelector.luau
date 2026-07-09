local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
local DEPRECATED_ImageSetButton = require(Modules.LuaApp.Components.DEPRECATED_ImageSetButton)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local UserGender = AuthCommon.Enums.UserGender
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local GetFIntLuaLoginGenderSelector = require(Modules.LuaApp.Flags.GetFIntLuaLoginGenderSelector)
local RegisterAuditContent = AuthCommon.Components.RegisterAuditContent
local GetFFlagEnableAuditForSinglePageSignUp = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAuditForSinglePageSignUp
local v21 = game:DefineFastFlag("FixGenderSelectorIconLightTheme", false)
local uDim2 = UDim2.new(0.8888888888888888, 0, 0.8888888888888888, 0)
local v23 = Roact.PureComponent:extend("SignUpGenderSelector")

v23.defaultProps = {
	size = UDim2.new(1, 0, 0, 48)
}

function v23.init(p1) -- line: 57
	-- upvalues: UserGender (copy), EventStreamConstants (copy)
	p1.state = {
		hoverRight = false,
		hoverLeft = false,
		gender = UserGender.Unknown
	}
	p1.isMounted = false

	function p1.onGenderSelected(p2) -- line: 66
		-- upvalues: UserGender (copy), p1 (copy), EventStreamConstants (copy)
		spawn(function() -- line: 67
			-- upvalues: p2 (ref), UserGender (copy), p1 (copy), EventStreamConstants (copy)
			if p2 == UserGender.Male then
				p1.props.analytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.GenderMale)
			else
				p1.props.analytics.reportButtonClicked(EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Button.GenderFemale)
			end

			if p1.isMounted then
				if p1.state.gender == p2 then
					p2 = UserGender.Unknown
				end

				p1:setState({
					gender = p2
				})

				if p1.props.onGenderChanged then
					p1.props.onGenderChanged(p2)
				end
			end
		end)
	end
	function p1.isSelectedGenderMale() -- line: 96
		-- upvalues: p1 (copy), UserGender (copy)
		return p1.state.gender == UserGender.Male
	end
	function p1.isSelectedGenderFemale() -- line: 100
		-- upvalues: p1 (copy), UserGender (copy)
		return p1.state.gender == UserGender.Female
	end
	function p1.onMouseEnterRight() -- line: 104
		-- upvalues: p1 (copy)
		if p1.isMounted then
			p1:setState({
				hoverRight = true
			})
		end
	end
	function p1.onMouseLeaveRight() -- line: 112
		-- upvalues: p1 (copy)
		if p1.isMounted then
			p1:setState({
				hoverRight = false
			})
		end
	end
	function p1.onMouseEnterLeft() -- line: 120
		-- upvalues: p1 (copy)
		if p1.isMounted then
			p1:setState({
				hoverLeft = true
			})
		end
	end
	function p1.onMouseLeaveLeft() -- line: 128
		-- upvalues: p1 (copy)
		if p1.isMounted then
			p1:setState({
				hoverLeft = false
			})
		end
	end
end
function v23.didMount(p3) -- line: 137
	p3.isMounted = true
end
function v23.willUnmount(p4) -- line: 141
	p4.isMounted = false
end
function v23.render(p5) -- line: 145
	-- upvalues: GetFIntLuaLoginGenderSelector (copy), withStyle (copy), withLocalization (copy), Roact (copy), FitChildren (copy), FitTextLabel (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), RegisterAuditContent (copy), ImageSetLabel (copy), GetImageData (copy), DEPRECATED_ImageSetButton (copy), UserGender (copy), uDim2 (copy), Images (copy), v21 (copy)
	local layoutOrder = p5.props.layoutOrder
	local size = p5.props.size
	local v30 = GetFIntLuaLoginGenderSelector() ~= 1 and "Authentication.SignUp.Label.Gender" or "Authentication.SignUp.Label.OptionalGender"

	return withStyle(function(p6) -- line: 150
		-- upvalues: withLocalization (copy), GetFIntLuaLoginGenderSelector (copy), Roact (copy), FitChildren (copy), layoutOrder (copy), FitTextLabel (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), p5 (copy), RegisterAuditContent (copy), v30 (copy), size (copy), ImageSetLabel (copy), GetImageData (copy), DEPRECATED_ImageSetButton (copy), UserGender (copy), uDim2 (copy), Images (copy), v21 (copy)
		return withLocalization({
			titleText = GetFIntLuaLoginGenderSelector() ~= 1 and "Authentication.SignUp.Label.Gender" or "Authentication.SignUp.Label.OptionalGender"
		})(function(p7) -- line: 153
			-- upvalues: Roact (copy), FitChildren (copy), layoutOrder (copy), FitTextLabel (copy), p6 (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), p5 (copy), RegisterAuditContent (copy), v30 (copy), size (copy), ImageSetLabel (copy), GetImageData (copy), DEPRECATED_ImageSetButton (copy), UserGender (copy), uDim2 (copy), Images (copy), v21 (copy)
			return Roact.createElement(FitChildren.FitFrame, {
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5)
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5)
				}),
				Title = p7.titleText and Roact.createElement(FitTextLabel, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					fitAxis = FitChildren.FitAxis.Height,
					Text = p7.titleText or "",
					Font = p6.Font.CaptionHeader.Font,
					TextSize = p6.Font.BaseSize * p6.Font.CaptionHeader.RelativeSize,
					TextColor3 = p6.Theme.TextEmphasis.Color,
					TextTransparency = p6.Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				RegisterTitleAuditContent = if not GetFFlagEnableAuditForSinglePageSignUp() or (not p5.props.enableAuditContentCapture or not p7.titleText) then nil else Roact.createElement(RegisterAuditContent, {
					translationKey = v30,
					translatedSourceString = p7.titleText
				}),
				Frame = Roact.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = size
				}, {
					Boundary = Roact.createElement(ImageSetLabel, {
						ZIndex = 3,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(9, 9, 9, 9),
						Image = GetImageData("LuaApp/buttons/buttonStroke") or "LuaApp/buttons/buttonStroke",
						ImageColor3 = p6.Theme.SecondaryDefault.Color
					}),
					BackgroundImage = Roact.createElement(ImageSetLabel, {
						ZIndex = 1,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(9, 9, 9, 9),
						Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
						ImageColor3 = p6.Theme.SecondaryDefault.Color
					}, {
						UIListLayout2 = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 1)
						}),
						Left = Roact.createElement(DEPRECATED_ImageSetButton, {
							LayoutOrder = 1,
							Size = UDim2.new(0.5, 0, 1, 0),
							AutoButtonColor = false,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(7, 8, 7, 8),
							ClipsDescendants = true,
							Image = "LuaApp/buttons/buttonLeftFill",
							ImageColor3 = p6.Theme.BackgroundContrast.Color,
							ImageTransparency = 0,
							[Roact.Event.Activated] = function() -- line: 238
								-- upvalues: p5 (copy), UserGender (copy)
								p5.onGenderSelected(UserGender.Female)
							end,
							[Roact.Event.MouseEnter] = p5.onMouseEnterLeft,
							[Roact.Event.MouseLeave] = p5.onMouseLeaveLeft
						}, {
							LeftIcon = Roact.createElement(ImageSetLabel, {
								LayoutOrder = 1,
								BorderSizePixel = 0,
								ClipsDescendants = true,
								BackgroundTransparency = 1,
								Size = uDim2,
								ScaleType = Enum.ScaleType.Fit,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								AnchorPoint = Vector2.new(0.5, 0.5),
								Image = if not p5.isSelectedGenderFemale() then Images["icons/common/gender_female"] else Images["icons/common/gender_female_selected"],
								ImageColor3 = if not v21 then nil else p6.Theme.IconEmphasis.Color,
								ImageTransparency = if not v21 then p6.Theme.BackgroundUIDefault.Transparency else p6.Theme.IconEmphasis.Transparency
							})
						}),
						Right = Roact.createElement(DEPRECATED_ImageSetButton, {
							LayoutOrder = 2,
							Size = UDim2.new(0.5, -1, 1, 0),
							AutoButtonColor = false,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(1, 8, 1, 8),
							ClipsDescendants = true,
							Image = "LuaApp/buttons/buttonRightFill",
							ImageColor3 = p6.Theme.BackgroundContrast.Color,
							ImageTransparency = 0,
							[Roact.Event.Activated] = function() -- line: 278
								-- upvalues: p5 (copy), UserGender (copy)
								p5.onGenderSelected(UserGender.Male)
							end,
							[Roact.Event.MouseEnter] = p5.onMouseEnterRight,
							[Roact.Event.MouseLeave] = p5.onMouseLeaveRight
						}, {
							RightIcon = Roact.createElement(ImageSetLabel, {
								LayoutOrder = 1,
								BorderSizePixel = 0,
								ClipsDescendants = true,
								BackgroundTransparency = 1,
								Size = uDim2,
								ScaleType = Enum.ScaleType.Fit,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								AnchorPoint = Vector2.new(0.5, 0.5),
								Image = if not p5.isSelectedGenderMale() then Images["icons/common/gender_male"] else Images["icons/common/gender_male_selected"],
								ImageColor3 = if not v21 then nil else p6.Theme.IconEmphasis.Color,
								ImageTransparency = if not v21 then p6.Theme.BackgroundUIDefault.Transparency else p6.Theme.IconEmphasis.Transparency
							})
						})
					})
				})
			})
		end)
	end)
end

return (RoactServices.connect({
	analytics = RoactAnalyticsAuthEvents
})(v23))
