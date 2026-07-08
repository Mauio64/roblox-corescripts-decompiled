local CorePackages = game:GetService("CorePackages")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Skeleton = Foundation.Skeleton
local FoundationImage = Foundation.Image
local View = Foundation.View

return function(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), ContentProvider (copy), RunService (copy), View (copy), Skeleton (copy), FoundationImage (copy)
	local v10 = React.useRef(nil)
	local v11, v12 = React.useState(false)
	local v13 = React.useRef(false)
	local v14 = React.useCallback(function(p1) -- line: 37
		-- upvalues: v13 (copy), t1 (copy)
		if p1 == v13.current then
			return
		end

		v13.current = p1

		if t1.onImageStateChanged then
			t1.onImageStateChanged(p1)
		end
	end, { t1.onImageStateChanged })

	React.useEffect(function() -- line: 48
		-- upvalues: t1 (copy), v12 (copy), v14 (copy), ContentProvider (copy), v10 (copy), RunService (copy)
		local t1Image = t1.Image

		if not t1Image then
			v12(false)
			v14(false)

			return
		end

		local v17 = time()

		local function checkImageState() -- line: 57
			-- upvalues: ContentProvider (copy), t1Image (copy), v17 (copy), v10 (copy), v14 (copy), v12 (copy)
			local AssetFetchStatus = ContentProvider:GetAssetFetchStatus(t1Image)
			local v23 = time() - v17 >= 1
			local v24 = AssetFetchStatus == Enum.AssetFetchStatus.Success or v23 and AssetFetchStatus == Enum.AssetFetchStatus.None
			local v25 = v10.current and v10.current.IsLoaded or v24

			v14(v25)

			local v26 = AssetFetchStatus == Enum.AssetFetchStatus.Failure or AssetFetchStatus == Enum.AssetFetchStatus.TimedOut
			local v27 = v25 or v26

			v12(v27)

			return v27
		end

		if checkImageState() then
			return
		end

		local u19 = nil

		local function disconnect() -- line: 79
			-- upvalues: u19 (ref)
			if not u19 then
				return
			end

			for _, v29 in u19 do
				v29:Disconnect()
			end

			u19 = nil
		end
		local function onStateMayHaveChanged() -- line: 90
			-- upvalues: checkImageState (copy), u19 (ref)
			if checkImageState() then
				if not u19 then
					return
				end

				for _, v31 in u19 do
					v31:Disconnect()
				end

				u19 = nil
			end
		end

		u19 = {
			ContentProvider:GetAssetFetchStatusChangedSignal(t1Image):Connect(onStateMayHaveChanged),
			RunService.RenderStepped:Connect(onStateMayHaveChanged)
		}

		return function() -- line: 101
			-- upvalues: u19 (ref)
			if not u19 then
				return
			end

			for _, v33 in u19 do
				v33:Disconnect()
			end

			u19 = nil
		end
	end, {
		t1.Image,
		v14
	})

	return React.createElement(View, {
		Size = t1.Size,
		SizeConstraint = t1.SizeConstraint,
		LayoutOrder = t1.LayoutOrder
	}, {
		skeleton = if v11 then nil else React.createElement(Skeleton, {
			tag = "size-full-full"
		}),
		image = if not t1.Image then nil else React.createElement(FoundationImage, {
			BackgroundTransparency = 1,
			ZIndex = 2,
			ref = v10,
			tag = `size-full-full { t1.tag }`,
			Image = t1.Image,
			onActivated = t1.onActivated
		})
	})
end
