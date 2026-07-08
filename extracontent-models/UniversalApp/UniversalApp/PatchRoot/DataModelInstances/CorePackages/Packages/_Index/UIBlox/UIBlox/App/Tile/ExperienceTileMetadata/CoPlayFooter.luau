local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UIBloxConfig = require(ParentParent.UIBloxConfig)
local Cryo = require(ParentParentParent.Cryo)
local React = require(ParentParentParent.React)
local Label = require(ParentParent.Core.ImageSet.ImageSetComponent).Label
local GenericTextLabel = require(ParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local useStyle = require(ParentParent.Core.Style.useStyle)

require(ParentParent.App.Style.StyleTypes)
require(ParentParent.App.Style.Fonts)

local t1 = {
	faceGroupCount = 3,
	maxBadgeDisplayNumber = 99,
	showEmphasisBorder = false,
	size = UDim2.fromScale(1, 1),
	styleProps = {}
}
local t2 = {
	containerGap = 6,
	faceGroupGap = -9,
	faceBorderWidth = 3,
	faceBorderRadius = 50,
	faceWidth = 24,
	faceHeight = 24,
	badgeBorderWidth = 3,
	badgeBorderRadius = 50,
	badgeSpacingLeading = 9,
	badgeSpacingTrailing = 9,
	badgeHeight = 24
}

local function getAvatarImage(s1: string) -- line: 136
	return string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=150&h=150", (tostring(s1)))
end
local function renderCornerStroke(t3: {[any]: any}) -- line: 140
	-- upvalues: React (copy)
	return React.createElement(React.Fragment, nil, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, t3.borderRadius)
		}),
		Stroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = t3.borderColor.Color,
			Transparency = t3.borderColor.Transparency,
			Thickness = t3.borderWidth
		})
	})
end
local function renderEmphasisBorder(n1: number, t4: {[any]: any}, p1, n2: number?) -- line: 154
	-- upvalues: React (copy), renderCornerStroke (copy)
	local Theme = p1.Theme
	local v25 = n1 - 1
	local v26 = (1 - n1) / 2

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, v26, 0, v26),
		Size = UDim2.new(1, v25, 1, v25),
		ZIndex = n2
	}, { renderCornerStroke({
		borderWidth = 1,
		borderColor = Theme.ContextualPrimaryDefault,
		borderRadius = t4.badgeBorderRadius
	}) })
end
local function renderBadge(t5: {[any]: any}, t6: {[any]: any}, p2) -- line: 177
	-- upvalues: React (copy), renderCornerStroke (copy), renderEmphasisBorder (copy)
	local v30 = if not (t5.usersCount > t5.maxDisplayNumber) then tostring(t5.usersCount) else tostring(t5.maxDisplayNumber) .. "+"
	local Theme = p2.Theme
	local p2Font = p2.Font
	local v33 = t6.badgeBackgroundColor or Theme.BackgroundUIDefault
	local badgeBorderWidth = t6.badgeBorderWidth
	local v35 = t6.badgeBorderColor or p2.Theme.BackgroundDefault
	local badgeBorderRadius = t6.badgeBorderRadius
	local badgeSpacingLeading = t6.badgeSpacingLeading
	local badgeSpacingTrailing = t6.badgeSpacingTrailing
	local badgeHeight = t6.badgeHeight
	local v40 = t6.badgeContentColor or Theme.TextMuted
	local v41 = React.createElement("Frame", {
		BorderSizePixel = 0,
		LayoutOrder = t5.layoutOrder,
		ZIndex = t5.ZIndex,
		Size = UDim2.fromOffset(0, badgeHeight),
		BackgroundColor3 = v33.Color,
		BackgroundTransparency = v33.Transparency,
		AutomaticSize = Enum.AutomaticSize.X
	}, {
		renderCornerStroke({
			borderWidth = badgeBorderWidth,
			borderColor = v35,
			borderRadius = badgeBorderRadius
		}),
		SizeConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(badgeHeight, 0)
		}),
		Content = React.createElement("TextLabel", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = v30,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			Font = p2Font.CaptionHeader.Font,
			TextSize = p2Font.BaseSize * p2Font.CaptionHeader.RelativeSize,
			TextColor3 = v40.Color,
			TextTransparency = v40.Transparency,
			AutomaticSize = Enum.AutomaticSize.X,
			ZIndex = t5.ZIndex + 1
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, badgeSpacingLeading),
				PaddingRight = UDim.new(0, badgeSpacingTrailing)
			})
		})
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = t5.layoutOrder,
		ZIndex = t5.ZIndex,
		Size = UDim2.fromOffset(0, badgeHeight),
		BackgroundColor3 = v33.Color,
		AutomaticSize = Enum.AutomaticSize.X
	}, {
		BadgeContainer = v41,
		emphasisBorder = if not t5.showEmphasisBorder then nil else renderEmphasisBorder(badgeBorderWidth, t6, p2, t5.ZIndex + 1)
	})
end
local function renderFaceImage(t7: {[any]: any}, t8: {[any]: any}, p3) -- line: 251
	-- upvalues: React (copy), Label (copy), renderCornerStroke (copy), renderEmphasisBorder (copy)
	local v45 = t8.faceBackgroundColor or p3.Theme.TextDefault
	local faceBorderWidth = t8.faceBorderWidth
	local v47 = t8.faceBorderColor or p3.Theme.BackgroundDefault
	local faceBorderRadius = t8.faceBorderRadius
	local faceWidth = t8.faceWidth
	local faceHeight = t8.faceHeight
	local createElement = React.createElement
	local v52 = Label
	local t9 = {
		BorderSizePixel = 0,
		LayoutOrder = t7.layoutOrder,
		ZIndex = t7.ZIndex,
		Size = UDim2.fromOffset(faceWidth, faceHeight)
	}
	local user = t7.user

	t9.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=150&h=150", (tostring(user)))
	t9.BackgroundColor3 = v45.Color
	t9.BackgroundTransparency = v45.Transparency

	return createElement(v52, t9, {
		renderCornerStroke({
			borderWidth = faceBorderWidth,
			borderColor = v47,
			borderRadius = faceBorderRadius
		}),
		emphasisBorder = if not t7.showEmphasisBorder then nil else renderEmphasisBorder(faceBorderWidth, t8, p3, t7.ZIndex + 1)
	})
end
local function renderFaces(t10: {[any]: any}, t11: {[any]: any}, p4, n3: number, b1: boolean, n4: number) -- line: 278
	-- upvalues: React (copy), renderBadge (copy), renderFaceImage (copy)
	local users = t10.users
	local faceGroupGap = t11.faceGroupGap
	local badgeBorderWidth = t11.badgeBorderWidth
	local faceBorderWidth = t11.faceBorderWidth
	local v65 = math.max(badgeBorderWidth, faceBorderWidth)
	local t12 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, faceGroupGap)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, badgeBorderWidth),
			PaddingTop = UDim.new(0, v65),
			PaddingRight = UDim.new(0, faceBorderWidth),
			PaddingBottom = UDim.new(0, v65)
		}),
		Badge = if not b1 then nil else renderBadge({
			layoutOrder = 0,
			usersCount = #users,
			ZIndex = n3 + 1,
			maxDisplayNumber = t10.maxBadgeDisplayNumber,
			showEmphasisBorder = t10.showEmphasisBorder
		}, t11, p4)
	}

	for i = 1, math.min(n4, #users) do
		t12["Face_" .. i] = renderFaceImage({
			user = users[i],
			layoutOrder = i,
			ZIndex = n3 - i,
			showEmphasisBorder = t10.showEmphasisBorder
		}, t11, p4)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.XY
	}, t12)
end
local function CoPlayFooter(t13: {[any]: any}) -- line: 332
	-- upvalues: Cryo (copy), t1 (copy), UIBloxConfig (copy), useStyle (copy), React (copy), t2 (copy), renderFaces (copy), GenericTextLabel (copy)
	local v69 = Cryo.Dictionary.join(t1, t13)

	if not UIBloxConfig.fixCoplayFooterConditionalHooks and (not v69.users or #v69.users == 0) then
		return nil
	end

	local v70 = useStyle()
	local v71, v72 = React.useBinding(Vector2.new(0, 0))
	local v73 = Cryo.Dictionary.join(t2, v69.styleProps)
	local v74 = nil

	if UIBloxConfig.fixCoplayFooterConditionalHooks then
		v74 = React.useCallback(function(p5) -- line: 346
			-- upvalues: v72 (copy)
			v72(p5.AbsoluteSize)
		end, { v72 })

		if not v69.users or #v69.users == 0 then
			return nil
		end
	end

	local containerGap = v73.containerGap
	local v76 = v73.labelContentColor or v70.Theme.TextMuted
	local faceGroupCount = v69.faceGroupCount
	local v78 = #v69.users > faceGroupCount + 1

	if not v78 then
		faceGroupCount += 1
	end

	local v79 = faceGroupCount + 1

	if not UIBloxConfig.fixCoplayFooterConditionalHooks then
		v74 = React.useCallback(function(p6) -- line: 367
			-- upvalues: v72 (copy)
			v72(p6.AbsoluteSize)
		end, { v72 })
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = v69.size,
		Position = v69.position,
		AnchorPoint = v69.anchorPoint,
		LayoutOrder = v69.layoutOrder
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, containerGap)
		}),
		FacesFrame = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY,
			[React.Change.AbsoluteSize] = v74
		}, {
			Faces = renderFaces(v69, v73, v70, v79, v78, faceGroupCount)
		}),
		LabelFrame = if not v69.labelText then nil else React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v71:map(function(vector2: Vector2) -- line: 397
				-- upvalues: containerGap (copy)
				return UDim2.new(1, -vector2.X - containerGap, 1, 0)
			end)
		}, {
			Label = React.createElement(GenericTextLabel, {
				TextWrapped = false,
				Size = UDim2.fromScale(1, 1),
				Text = v69.labelText,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				fontStyle = v73.fontStyle or v70.Font.CaptionBody,
				colorStyle = v76
			})
		})
	})
end

return CoPlayFooter
