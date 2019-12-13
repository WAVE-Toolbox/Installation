SIMULATION_COMMIT=ae5592cc0025fb942a66a2f2975fe66ed62454a7
Geographer_COMMIT=881471cb2429026e960d2a63bd6a6c4b664c5ac4
INVERSION_COMMIT=b5e7a3533ee8fc836c5331412cab1b87fbca48a1
LAMA_COMMIT=5bf11640771dacdcb7dd2f609422de6e06c1237b
dir=$(pwd)

# Clone Lama
git clone https://gitlab.scai.fraunhofer.de/hpcpublic/lama.git
pushd lama && git checkout ${LAMA_COMMIT}; popd

# Configure Lama
pushd lama && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=../install ../scai; popd

# fast compile version
#pushd lama && mkdir build && cd build && cmake ../scai -DSCAI_HOST_TYPES_LIST="float;double;scai::ComplexFloat;scai::ComplexDouble" -DSCAI_MODULES=partitioning -DSCAI_BLAS_LIBRARY=INTERNALBLAS -DUSE_DOXYGEN=0 -DUSE_SPHINX=0  -DUSE_ZLIB=0 -DUSE_PNG=0 -DUSE_FFTW=0 -DUSE_JAVA=0 -DUSE_BOOST_TEST=0 -DUSE_CUDA=0 -DCMAKE_INSTALL_PREFIX=../install; popd

# Compile Lama
pushd lama/build && make -j4 && make install; popd

# Clone Geographer
git clone https://github.com/WAVE-Toolbox/geographer.git
pushd geographer && git checkout ${Geographer_COMMIT}; popd

# Configure Geographer

# depending on the CMake Version:
#pushd geographer && mkdir build && cd build && SCAI_DIR=${dir}/lama/install/ cmake -DCMAKE_INSTALL_PREFIX=../install ..; popd 
pushd geographer && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=../install \
   -DSCAI_DIR=${dir}/lama/install/ ..; popd

# Compile Geographer
pushd geographer/build && make -j4 && make install; popd

# Clone WAVE-Simulation
git clone https://github.com/WAVE-Toolbox/WAVE-Simulation.git
pushd WAVE-Simulation && git checkout ${SIMULATION_COMMIT}; popd

# Configure WAVE-Simulation
pushd WAVE-Simulation && mkdir build; popd
pushd WAVE-Simulation/build &&  cmake -DCMAKE_INSTALL_PREFIX=../install \
-DSCAI_DIR=${dir}/lama/install/ -DGeographer_DIR=${dir}/geographer/install/share/cmake/geographer/ ../src; popd

# Compile WAVE-Simulation
pushd WAVE-Simulation/build && make -j4 && make install; popd

# Clone WAVE-Inversion
git clone https://github.com/WAVE-Toolbox/WAVE-Inversion.git
pushd WAVE-Inversion && git checkout ${INVERSION_COMMIT}; popd

# Configure WAVE-Inversion
pushd WAVE-Inversion && mkdir build; popd
pushd WAVE-Inversion/build &&  cmake -DCMAKE_INSTALL_PREFIX=../install \
 -DSimulation_DIR=${dir}/WAVE-Simulation/install/share/cmake/Simulation ../src; popd

# Compile WAVE-Inversion
pushd WAVE-Inversion/build && make -j4 && make install; popd
