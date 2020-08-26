local _M = {}

function _M.new(x, y)
    return { x, y }
end

function _M.centroid(points, nrep)
    local x = 0.0
    local y = 0.0
    local npoints = #points
    for _ = 1, nrep do
        x = 0.0
        y = 0.0
        for i = 1, npoints do
            local p = points[i]
            x = x + p[1]
            y = y + p[2]
        end
    end
    return { x / npoints, y / npoints }
end

function _M.all(N, nrep)
    local arr = {}
    for i = 1, N do
        local d = i * 3.1415
        arr[i] = _M.new(d, d)
    end

    return _M.centroid(arr, nrep)
end

return _M
