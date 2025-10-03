-- 4th order  Markov chain pulses
pulsewidth = 0.01

function PulseOutput(OutputNum)
  output[OutputNum].volts = 5
  clock.run(function()
    clock.sleep(pulsewidth)
    output[OutputNum].volts = 0
  end)
--  print(string.format("Pulse -> output[%d]", OutputNum))
end

function RowInvert(M)
  for i = 1, math.floor(#M / 2) do
    M[i], M[#M-i+1] = M[#M-i+1], M[i]
  end
end

function ColumnInvert(M)
    for i = 1, #M do
        for j = 1, math.floor(#M/2) do
            M[i][j], M[i][#M-j+1] = M[i][#M-j+1], M[i][j]
        end
    end
end

function RotateU()
local temp = table.remove(P, 4)
table.insert(P, 1, temp)
end

function RotateD()
local temp = table.remove(P, 1)
table.insert(P, 4, temp)
end

local states = {1, 2, 3, 4}
local idx = { A=1, B=2, C=3, D=4 }
local names = { "A", "B", "C", "D" }

bStates = {
  RowInvert,
  ColumnInvert,
  RotateU,
  RotateD
}

-- state transition matrices
P = {
  {0.4,0.3,0.2,0.1},
  {0.3,0.2,0.1,0.4},
  {0.2,0.1,0.4,0.3},
  {0.1,0.4,0.3,0.2},
}

local Q = {
{0.4,0.3,0.2,0.1},
{0.1,0.3,0.2,0.4},
{0.3,0.1,0.4,0.2},
{0.2,0.4,0.1,0.3}
}

function sample_row(row)
  local r = math.random()
  local acc = 0
  for j = 1, #row do
    acc = acc + row[j]
    if r <= acc then return j end
  end
  return #row
end

-- current state
local current = idx.A
local bCurrent = 1

local function step()
  local out_num = states[current]
  PulseOutput(out_num)
  local next_state = sample_row(P[current])
  print("Next state -> " .. names[next_state])
  current = next_state
end

local function rotorvator()
        local prob, r, accu = Q[bCurrent], math.random(), 0
        for i = 1, #prob do
                accu = accu + prob[i]
                if r <= accu then
                        bCurrent = i
                break
                end
        end
        bStates[bCurrent](P)
        print("Chain B applied state " .. bCurrent)
end

-- Function(s) executed on Input Detection
input[1].change = function()
        step()
end
input[2].change = function()
        rotorvator()
end

-- Setting CV Inputs 1&2 to expect rising edges of clock signal
input[1].mode("change", 1.0, 0.1, "rising")
input[2].mode("change", 1.0, 0.1, "rising")




