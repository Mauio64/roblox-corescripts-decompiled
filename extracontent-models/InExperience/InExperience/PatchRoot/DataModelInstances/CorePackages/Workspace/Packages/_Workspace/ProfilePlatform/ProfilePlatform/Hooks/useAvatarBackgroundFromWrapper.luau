local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Enums = require(ProfilePlatform.Common.Enums)
local insertServiceLoadAsset = require(ProfilePlatform.Utils.insertServiceLoadAsset)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)

local function parseAssetId(t1: {[any]: any}?) -- line: 14
	if t1 == nil then
		return nil
	end

	local assetId = t1.assetId

	if type(assetId) == "number" and assetId > 0 then
		return assetId
	end

	if type(assetId) == "string" then
		local num = tonumber(assetId)

		if num and num > 0 then
			return num
		end
	end

	return nil
end
local function findInnerImageId(p1) -- line: 37
	if type(p1) == "table" then
		local ImageId = p1.ImageId

		if type(ImageId) == "table" then
			local ImageIdValue = ImageId.Value

			if type(ImageIdValue) == "number" and ImageIdValue > 0 then
				return ImageIdValue
			end
		end

		return nil
	end

	if typeof(p1) ~= "Instance" then
		return nil
	end

	for _, descendant in ipairs(p1:GetDescendants()) do
		local ImageId = descendant:FindFirstChild("ImageId")

		if ImageId == nil or not ImageId:IsA("IntValue") and not ImageId:IsA("NumberValue") then
			continue
		end

		local ImageIdValue = ImageId.Value

		if type(ImageIdValue) == "number" and ImageIdValue > 0 then
			return ImageIdValue
		end
	end

	return nil
end
local function useAvatarBackgroundFromWrapper() -- line: 73
	-- upvalues: useProfileJsonComponent (copy), Enums (copy), React (copy), insertServiceLoadAsset (copy), findInnerImageId (copy)
	local v20 = useProfileJsonComponent(Enums.Components.ProfileBackground)
	local g22 = nil
	local v21 = nil

	if v20 == nil then
		v21 = nil
		g22 = true
	end

	if not g22 then
		v21 = v20.assetId

		if type(v21) == "number" and v21 > 0 then
			g22 = true
		end
	end

	repeat
		if g22 or (g22 or (g22 or type(v21) == "string")) then
			if not g22 then
				if not g22 then
					if not g22 then
						v21 = tonumber(v21)
					end
				end
			end

			if g22 or (g22 or (g22 or v21 and v21 > 0)) then
				g22 = false

				local v23 = v21
				local v24, v25 = React.useState(nil)

				React.useEffect(function() -- line: 81
					-- upvalues: v23 (copy), v25 (copy), insertServiceLoadAsset (copy), findInnerImageId (copy)
					if v23 == nil then
						v25(nil)

						return nil
					end

					local u26 = false

					task.spawn(function() -- line: 88
						-- upvalues: insertServiceLoadAsset (copy), v23 (copy), u26 (ref), findInnerImageId (copy), v25 (copy)
						local ok, result = pcall(function() -- line: 89
							-- upvalues: insertServiceLoadAsset (copy), v23 (copy)
							return insertServiceLoadAsset(v23)
						end)

						if not ok or (u26 or result == nil) then
							return
						end

						local v29 = findInnerImageId(result)

						if u26 then
							return
						end

						if v29 == nil then
							v25(nil)

							return
						end

						v25("rbxassetid://" .. tostring(v29))
					end)

					return function() -- line: 109
						-- upvalues: u26 (ref)
						u26 = true
					end
				end, {
					v23,
					v25
				})

				return v24
			end
		end

		v21 = nil
		g22 = true
	until not g22
end

return useAvatarBackgroundFromWrapper
