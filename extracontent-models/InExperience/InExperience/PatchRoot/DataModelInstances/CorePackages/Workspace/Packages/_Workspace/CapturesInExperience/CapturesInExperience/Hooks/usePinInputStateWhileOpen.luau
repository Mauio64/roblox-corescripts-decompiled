local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent.Parent

local React = require(parent.React)

local Default = Enum.MouseBehavior.Default

return function(flag: boolean?, p)
	React.useEffect(function()
		if not flag then
			return
		end

		local v

		if p == nil then
			v = UserInputService
		else
			v = p
		end

		local v2 = {
			MouseBehavior = v.MouseBehavior,
			MouseIconEnabled = v.MouseIconEnabled,
			MouseIcon = v.MouseIcon
		}

		local function pin(p2: string, p3) -- 6 equivalent calls inferred from this helper
			v[p2] = p3
		end

		pin("MouseBehavior", Default) -- inferred equivalent call
		pin("MouseIconEnabled", true) -- inferred equivalent call
		pin("MouseIcon", "") -- inferred equivalent call

		local function watch(propertyName: string, p2)
			return v:GetPropertyChangedSignal(propertyName):Connect(function()
				local v3 = v[propertyName]

				if v3 ~= p2 then
					v2[propertyName] = v3
					pin(propertyName, p2) -- inferred equivalent call
				end
			end)
		end

		local v3 = Default
		local v4 = "MouseBehavior"
		local v5 = "MouseIconEnabled"
		local v6 = true
		local v7 = {
			v:GetPropertyChangedSignal("MouseBehavior"):Connect(function()
				local v5 = v[v4]

				if v5 ~= v3 then
					v2[v4] = v5
					pin(v4, v3) -- inferred equivalent call
				end
			end),
			v:GetPropertyChangedSignal("MouseIconEnabled"):Connect(function()
				local v7 = v[v5]

				if v7 ~= v6 then
					v2[v5] = v7
					pin(v5, v6) -- inferred equivalent call
				end
			end),
			watch("MouseIcon", "")
		}

		return function()
			for _, connection in v7 do
				connection:Disconnect()
			end

			v.MouseBehavior = v2.MouseBehavior
			v.MouseIconEnabled = v2.MouseIconEnabled
			v.MouseIcon = v2.MouseIcon
		end
	end, { flag, p })
end
