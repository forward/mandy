# this job is pretty useless, it's just a pass though.
# but it does mean we can take advantage of the map/reduce shuffle and get nicely ordered keys.
job "Sort" do
  map_tasks 1
  reduce_tasks 1
end