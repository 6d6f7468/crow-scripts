
-- 4 state Markov chain pulses

local pulse_width = 0.01 -- (10ms)

-- (pulse function)
function PulseOutput(OutputNum)
  output[OutputNum].volts = 5
  clock.run(function()
    clock.sleep(pulse_width)
    output[OutputNum].volts = 0
  end)
  print(string.format("Pulse -> output[%d]", OutputNum))
end


local states = {1, 2, 3, 4}
local idx = { A=1, B=2, C=3, D=4 }
local names = { "A", "B", "C", "D" }


-- state transition matrix
local P = {
  {0.4,0.3,0.2,0.1},
  {0.3,0.2,0.1,0.4},
  {0.2,0.1,0.4,0.3},
  {0.1,0.4,0.3,0.2},
}

local function sample_row(row)
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


local function step()
  local out_num = states[current]
  PulseOutput(out_num)
  local next_state = sample_row(P[current])
  print("Next state -> " .. names[next_state])
  current = next_state
end

-- Function(s) executed on Input 1 Detection
input[1].change = function()
  step()
end

-- Setting CV Input 1 to expect rising edges of clock signal
input[1].mode("change", 1.0, 0.1, "rising")

