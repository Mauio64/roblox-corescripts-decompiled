local Parent = script:FindFirstAncestor("SceneManagement").Parent
local React = require(Parent.React)

function getCameraFacingCFrame(n1: number, cFrame: CFrame) -- line: 14
	local v6 = cFrame.Position + n1 * cFrame.LookVector

	return CFrame.lookAt(v6, cFrame.Position, cFrame.UpVector)
end
function getDimensionsToFillViewPort(n2: number, p1) -- line: 23
	local v9 = not (p1.ViewportSize.Y > 0) and 0 or p1.ViewportSize.X / p1.ViewportSize.Y
	local v10 = n2 * 2 * math.tan((math.rad(p1.FieldOfView / 2)))
	local v11 = v10 * v9

	return Vector2.new(v11, v10)
end

local function useCameraFacingGeometry(n3: number) -- line: 35
	-- upvalues: React (copy)
	local v13, v14 = React.useState(workspace.CurrentCamera)
	local v15, v16 = React.useBinding(Vector2.new())
	local v17, v18 = React.useBinding(CFrame.new())

	local function updateGeometry(p2) -- line: 40
		-- upvalues: v16 (copy), n3 (copy), v18 (copy)
		v16(getDimensionsToFillViewPort(n3, p2))
		v18(getCameraFacingCFrame(n3, p2.CFrame))
	end
	local function makeCameraPropConnections(p3) -- line: 45
		-- upvalues: v16 (copy), n3 (copy), v18 (copy)
		local t1 = {}

		for _, v25 in {
			"CFrame",
			"ViewportSize",
			"FieldOfView"
		} do
			table.insert(t1, p3:GetPropertyChangedSignal(v25):Connect(function() -- line: 50
				-- upvalues: p3 (copy), v16 (copy), n3 (copy), v18 (copy)
				local v29 = p3

				v16(getDimensionsToFillViewPort(n3, v29))
				v18(getCameraFacingCFrame(n3, v29.CFrame))
			end))
		end

		return t1
	end

	React.useEffect(function() -- line: 58
		-- upvalues: v14 (copy)
		local connection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 59
			-- upvalues: v14 (copy)
			v14(workspace.CurrentCamera)
		end)

		return function() -- line: 62
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 67
		-- upvalues: v13 (copy), makeCameraPropConnections (copy), v16 (copy), n3 (copy), v18 (copy)
		local u27 = nil

		if v13 then
			u27 = makeCameraPropConnections(v13)

			local v28 = v13

			v16(getDimensionsToFillViewPort(n3, v28))
			v18(getCameraFacingCFrame(n3, v28.CFrame))
		end

		return function() -- line: 74
			-- upvalues: u27 (ref)
			if u27 then
				for _, v31 in u27 do
					v31:Disconnect()
				end
			end
		end
	end, { v13 })

	return React.useMemo(function() -- line: 83
		-- upvalues: v15 (copy), v17 (copy)
		return {
			viewportFillDimensions = v15,
			cFrame = v17
		}
	end, {})
end

return useCameraFacingGeometry
