local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local Foundation = require(OnPlatformSurveysParent.Foundation)
local React = require(OnPlatformSurveysParent.React)
local Icon = Foundation.Icon
local IconVariant = Foundation.Enums.IconVariant
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local t1 = {}
local t2 = {
	{
		id = "1",
		icon = "thumb-down"
	},
	{
		id = "2",
		icon = "thumb-up"
	}
}

local function findChoice(p1, s1: string) -- line: 44
	-- upvalues: t1 (copy)
	for _, v17 in p1.choices or t1 do
		if s1 == v17.id then
			return v17
		end
	end

	return nil
end
local function ThumbsQuestion(t3: {[any]: any}) -- line: 53
	-- upvalues: useTokens (copy), React (copy), t2 (copy), t1 (copy), View (copy), Icon (copy), IconVariant (copy), FoundationText (copy)
	local v19 = useTokens()
	local question = t3.question
	local answer = t3.answer
	local v22 = t3.isDisabled == true
	local v23 = if answer.choiceIds == nil then nil else answer.choiceIds[1]
	local v24, v25 = React.useState(nil)
	local DefaultColor3 = v19.Color.Content.Default.Color3
	local t4 = {}
	local g34 = nil
	local v33 = nil

	for v28, v29 in t2 do
		local id = v29.id

		for _, v32 in question.choices or t1 do
			if id == v32.id then
				v33 = v32
				g34 = true
			end

			if g34 then
				break
			end
		end

		if not g34 then
			v33 = nil
		end

		g34 = false

		if v33 ~= nil then
			local v35 = v23 == v29.id
			local v36 = v24 == v29.id
			local v37 = if not v35 then not v36 and 0.92 or 0.85 else 0.75

			t4["Cell_" .. v29.id] = React.createElement(View, {
				tag = "col align-x-center gap-small auto-xy",
				LayoutOrder = v28
			}, {
				Button = React.createElement("TextButton", {
					Size = UDim2.fromOffset(76, 76),
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false,
					Active = not v22,
					Selectable = not v22,
					LayoutOrder = 1,
					[React.Tag] = "data-testid=thumb-" .. v29.id,
					[React.Event.Activated] = function() -- line: 91
						-- upvalues: v22 (copy), t3 (copy), v35 (copy), v29 (copy)
						if v22 then
							return
						end

						t3.onAnswerChanged({
							choiceIds = if not v35 then { v29.id } else {}
						})
					end,
					[React.Event.MouseEnter] = function() -- line: 100
						-- upvalues: v25 (copy), v29 (copy)
						v25(v29.id)
					end,
					[React.Event.MouseLeave] = function() -- line: 103
						-- upvalues: v25 (copy), v29 (copy)
						v25(function(s2: string?) -- line: 104
							-- upvalues: v29 (copy)
							if s2 == v29.id then
								return nil
							end

							return s2
						end)
					end
				}, {
					Backplate = React.createElement(View, {
						tag = "size-full radius-circle",
						ZIndex = 1,
						backgroundStyle = {
							Color3 = DefaultColor3,
							Transparency = v37
						}
					}),
					Icon = React.createElement(Icon, {
						size = 40,
						ZIndex = 2,
						name = v29.icon,
						variant = if not v35 then IconVariant.Regular else IconVariant.Filled,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5)
					})
				}),
				Label = React.createElement(FoundationText, {
					tag = "auto-xy text-body-medium text-align-x-center content-default",
					LayoutOrder = 2,
					Text = v33.label
				})
			})
		end
	end

	return React.createElement(View, {
		tag = "row flex-around align-y-top size-full-0 auto-y",
		LayoutOrder = t3.layoutOrder
	}, t4)
end

return React.memo(ThumbsQuestion)
