local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)

local Enums = require(ProfilePlatform.Common.Enums)
local insertServiceLoadAsset = require(ProfilePlatform.Utils.insertServiceLoadAsset)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)

local function parseAssetId(p)
	if p == nil then
		return nil
	end

	local assetId = p.assetId

	if type(assetId) == "number" and assetId > 0 then
		return assetId
	end

	if type(assetId) == "string" then
		local v = tonumber(assetId)

		if v and v > 0 then
			return v
		end
	end

	return nil
end

local function findInnerImageId(folder)
	if type(folder) == "table" then
		local imageId = folder.ImageId

		if type(imageId) == "table" then
			local value = imageId.Value

			if type(value) == "number" and value > 0 then
				return value
			end
		end

		return nil
	end

	if typeof(folder) ~= "Instance" then
		return nil
	end

	for _, descendant in ipairs(folder:GetDescendants()) do
		local imageId = descendant:FindFirstChild("ImageId")

		if not (imageId ~= nil and (imageId:IsA("IntValue") or imageId:IsA("NumberValue"))) then
			continue
		end

		local value = imageId.Value

		if type(value) == "number" and value > 0 then
			return value
		end
	end

	return nil
end

local function useAvatarBackgroundFromWrapper()
	local v = useProfileJsonComponent(Enums.Components.ProfileBackground)
	local assetId

	if v == nil then
		assetId = nil
	else
		assetId = v.assetId

		if type(assetId) ~= "number" or not (assetId > 0) then
			if type(assetId) == "string" then
				assetId = tonumber(assetId)

				if not (assetId and assetId > 0) then
					assetId = nil
				end
			else
				assetId = nil
			end
		end
	end

	local state, setState = React.useState(nil)

	React.useEffect(function()
		if assetId == nil then
			setState(nil)
			return nil
		end

		local flag = false
		task.spawn(function()
			local success, result = pcall(function()
				return insertServiceLoadAsset(assetId)
			end)

			if not success or flag or result == nil then
				return
			end

			local innerImageId = findInnerImageId(result)

			if flag then
				return
			end

			if innerImageId == nil then
				setState(nil)
			else
				setState("rbxassetid://" .. tostring(innerImageId))
			end
		end)

		return function()
			flag = true
		end
	end, { assetId, setState })

	return state
end

return useAvatarBackgroundFromWrapper
