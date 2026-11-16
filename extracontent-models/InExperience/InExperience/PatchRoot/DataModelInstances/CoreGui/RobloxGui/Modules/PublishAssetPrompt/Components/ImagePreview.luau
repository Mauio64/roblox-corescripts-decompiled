local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local Image = Foundation.Image
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function ImagePreview(p)
	local v = useTokens()

	local v2 = React.useMemo(function()
		return {
			{ id = "Black", style = v.Color.Extended.Black.Black_100 },
			{ id = "White", style = v.Color.Extended.White.White_100 },
			{
				id = "Checkerboard",
				style = v.Color.Extended.White.White_0,
				image = "rbxassetid://6372755229"
			}
		}
	end, { v })

	local state, setState = React.useState(1)

	local ref = React.useRef(false)
	local v3 = not p.autoRotateSeconds and 0 or p.autoRotateSeconds / #v2

	React.useEffect(function()
		if v3 <= 0 then
			return function() end
		end

		task.spawn(function()
			for _ = 2, #v2 do
				task.wait(v3)

				if ref.current then
					break
				end

				setState(function(p2)
					return p2 % #v2 + 1
				end)
			end
		end)

		return function()
			ref.current = true
		end
	end, { v3, v2 })

	local backgroundStyle, v4 = React.useBinding(v2[1].style)
	local time_300 = v.Time.Time_300

	React.useEffect(function()
		local value = backgroundStyle:getValue()
		local style = v2[state].style
		local flag = false

		task.spawn(function()
			local total = 0

			while total < time_300 do
				total += task.wait()

				if flag then
					break
				end

				local v5 = math.min(total / time_300, 1)
				v4({
					Color3 = value.Color3:Lerp(style.Color3, v5),
					Transparency = value.Transparency + (style.Transparency - value.Transparency) * v5
				})
			end
		end)

		return function()
			flag = true
		end
	end, { state, v2, time_300, backgroundStyle, v4 })

	local children = {}

	for k, v5 in v2 do
		local id = v5.id
		local createElement = React.createElement
		local v6 = {
			LayoutOrder = k,
			tag = {
				["size-350 radius-small"] = true,
				["stroke-thick stroke-emphasis"] = k == state,
				["stroke-standard stroke-default"] = k ~= state
			},
			backgroundStyle = v5.style,
			onActivated = function()
				ref.current = true
				setState(k)
			end,
			testId = `ImagePreviewBackgroundSwatch{v5.id}`
		}
		local checkerboard

		if v5.image then
			checkerboard = React.createElement(Image, {
					tag = "size-full radius-small",
					Image = v5.image,
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.fromOffset(v.Size.Size_150, v.Size.Size_150)
				})
				or nil
		end

		children[id] = createElement(View, v6, { Checkerboard = checkerboard })
	end

	return React.createElement(View, { tag = "col align-x-center gap-xsmall size-full" }, {
		Preview = React.createElement(Image, {
			LayoutOrder = 1,
			tag = "size-full aspect-1-1 radius-small clip",
			backgroundStyle = backgroundStyle,
			imageStyle = backgroundStyle:map(function(p2)
				return {
					Color3 = v.Color.Extended.White.White_100.Color3,
					Transparency = 1 - p2.Transparency
				}
			end),
			Image = "rbxassetid://6372755229",
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.fromOffset(v.Size.Size_400, v.Size.Size_400),
			testId = "ImagePreviewBackground"
		}, {
			Asset = React.createElement(Image, {
				tag = "size-full",
				ImageContent = p.imageContent,
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 2,
				testId = "ImagePreviewAsset"
			})
		}),
		Swatches = React.createElement(
			View,
			{ tag = "row gap-xsmall auto-xy", LayoutOrder = 2, testId = "ImagePreviewSwatches" },
			children
		)
	})
end

return ImagePreview
