local Version = require(script.Parent.Version)

return {
	parse_dsn = function(s1: string) -- line: 14
		if not s1 or s1 == "" then
			return nil, "DSN is required"
		end

		local v3, v4, v5 = s1:match("^(https?)://([^@]+)@(.+)$")

		if not v3 or not v4 or not v5 then
			return nil, "Invalid DSN format"
		end

		local v6, v7 = v4:match("^([^:]+):(.+)$")

		if not v6 then
			v6 = v4
			v7 = ""
		end

		if not v6 or v6 == "" then
			return nil, "Invalid DSN format"
		end

		local v8, v9 = v5:match("^([^/]+)(.*)$")

		if not v8 or not v9 or v9 == "" then
			return nil, "Invalid DSN format"
		end

		local v10 = v9:match("/([%d]+)$")

		if not v10 then
			return nil, "Could not extract project ID from DSN"
		end

		return {
			protocol = v3,
			public_key = v6,
			secret_key = v7 or "",
			host = v8,
			path = v9,
			project_id = v10
		}, nil
	end,
	build_ingest_url = function(t1: {[any]: any}) -- line: 59
		return `https://{ t1.host }/api/{ t1.project_id }/store/`
	end,
	build_envelope_url = function(t2: {[any]: any}) -- line: 63
		return `https://{ t2.host }/api/{ t2.project_id }/envelope/`
	end,
	build_auth_header = function(t3: {[any]: any}) -- line: 67
		-- upvalues: Version (copy)
		return `Sentry sentry_version={ Version.SENTRY_VERSION }, sentry_key={ t3.public_key }, sentry_client=sentry-lua/{ Version.SDK_VERSION }`
	end
}
