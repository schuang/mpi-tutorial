CXX       = mpicxx
CXXFLAGS  = -g -Wall
EXE       = hello gather scatter mpi_version process_name \
            reduce_sum bcast

all: $(EXE)

hello: hello.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<
gather: gather.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<
bcast: bcast.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<
scatter: scatter.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<
mpi_version: mpi_version.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<
process_name: process_name.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<
reduce_sum: reduce_sum.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

.PHONY: clean

clean:
	rm -f $(EXE) *~ *.o data.* a.out
