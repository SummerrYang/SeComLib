#SeComLib
#Copyright 2012-2013 TU Delft, Information Security & Privacy Lab (http://isplab.tudelft.nl/)
#
#Contributors:
#Inald Lagendijk (R.L.Lagendijk@TUDelft.nl)
#Mihai Todor (todormihai@gmail.com)
#Thijs Veugen (P.J.M.Veugen@tudelft.nl)
#Zekeriya Erkin (z.erkin@tudelft.nl)
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

#@file Makefile
#@brief The Linux Makefile
#@author Mihai Todor (todormihai@gmail.com)

#Declare phony targets
.PHONY: release debug clean directories libs exes test
.DEFAULT_GOAL := release

#Compiler
CXX = g++
#Linker
LINKER = g++

#The contents of this variable will be passed to the -D compiler flag
BIG_NUMBER_LIB_NAME = LIB_GMP

#Specify the big number library for the linker
BIG_NUMBER_LIB = -lgmp

#3rd party library dependencies
BOOST_LINK_LIBRARIES = -lboost_timer-gcc47-mt-s-1_53 -lboost_chrono-gcc47-mt-s-1_53 -lboost_system-gcc47-mt-s-1_53 -lboost_filesystem-gcc47-mt-s-1_53
EXTRA_LINK_LIBRARIES = -lrt

#Release compiler flags
RELEASE_OPTIMIZATION_LEVEL = -O2
RELEASE_DEFINES = -D NDEBUG

#Debug compiler flags
DEBUG_OPTIMIZATION_LEVEL = -O0
#make both GCC and MSVC happy
DEBUG_DEFINES = -D DEBUG -D _DEBUG
#enable symbol generation
DEBUG_FLAGS = -g

#Flags
#use -std=c++0x for GCC < 4.7
#include the current directory as well
#keep the BOOST library in a central location, instead of our /include
#We need to suppress some warnings generated by VS2010 (with /W4) by using some pragmas that are not recognised by GCC => -Wno-unknown-pragmas
#Can't use -Wsign-conversion (mainly) because BOOST generates many such errors...
CXXFLAGS = -Wall -Wextra -Wconversion -Wno-unknown-pragmas -pedantic -std=c++11 -I $(BIG_NUMBER_LIB_DIR)/include -I $(BOOST_INCLUDE) -I $(INCLUDE_DIR) -I . -D $(BIG_NUMBER_LIB_NAME)
LIBCXXFLAGS = $(CXXFLAGS) -c
#use -static only if the 3rd party libraries have the static build compiled on the system
LDFLAGS = -static -L $(BIG_NUMBER_LIB_DIR)/lib -L $(BOOST_DIR)/lib -L $(LIB_DIR) -L $(OUTPUT_DIR) $(BIG_NUMBER_LIB) $(BOOST_LINK_LIBRARIES) $(EXTRA_LINK_LIBRARIES)

#Directories
#should contain the static library in the "lib" subdirectory and the headers in the "include" subdirectory
BIG_NUMBER_LIB_DIR = /home/michael/workspace/_lib/gmp
BOOST_DIR = /home/michael/workspace/_lib/boost
BOOST_INCLUDE = $(BOOST_DIR)/include/boost-1_53
OUTPUT_DIR = _output/linux
INTERMEDIATE_DIR = _intermediate/linux
#project specific 3rd party libraries
INCLUDE_DIR = include
LIB_DIR = lib/linux
RESOURCES_DIR = resources

#Project libraries directories
UTILS_DIR = utils
CORE_DIR = core
PRIVATE_RECOMMENDATIONS_UTILS_DIR = private_recommendations_utils
SECURE_FACE_RECOGNITION_UTILS_DIR = secure_face_recognition_utils

#Project applications directories
PRIVATE_RECOMMENDATIONS_DIR = private_recommendations
PRIVATE_RECOMMENDATIONS_DATA_PACKING_DIR = private_recommendations_data_packing
SECURE_EXTREMUM_SELECTION_DIR = secure_extremum_selection
SECURE_FACE_RECOGNITION_DIR = secure_face_recognition
SECURE_RECOMMENDATIONS_DIR = secure_recommendations
TEST_DIR = test

#Declare directories which need to be created ($(INTERMEDIATE_DIR) will be created automatically when building the .o files, but this looks clearer)
CREATE_DIRECTORIES = $(INTERMEDIATE_DIR) $(OUTPUT_DIR)

#Release build
#prepend required compiler flags
release: CXXFLAGS := $(RELEASE_OPTIMIZATION_LEVEL) $(RELEASE_DEFINES) $(CXXFLAGS)
#no automatic dependency modification detection implemented; rebuild everything each time to avoid inconsistencies
release: directories clean libs exes
	cp $(RESOURCES_DIR)/config.xml $(OUTPUT_DIR)

#Debug build
#prepend required compiler flags
debug: CXXFLAGS := $(DEBUG_OPTIMIZATION_LEVEL) $(DEBUG_DEFINES) $(DEBUG_FLAGS) $(CXXFLAGS)
#no automatic dependency modification detection implemented; rebuild everything each time to avoid inconsistencies
debug: directories clean libs exes
	cp $(RESOURCES_DIR)/config.xml $(OUTPUT_DIR)

#Create required directories
directories: $(CREATE_DIRECTORIES)
$(CREATE_DIRECTORIES):
	mkdir -p $@

#Build the project libraries
libs: directories $(OUTPUT_DIR)/libUtils.a $(OUTPUT_DIR)/libCore.a $(OUTPUT_DIR)/libPrivateRecommendationsUtils.a $(OUTPUT_DIR)/libSecureFaceRecognitionUtils.a

#Build the executables
exes: directories $(OUTPUT_DIR)/PrivateRecommendations $(OUTPUT_DIR)/PrivateRecommendationsDataPacking $(OUTPUT_DIR)/SecureExtremumSelection $(OUTPUT_DIR)/SecureFaceRecognition $(OUTPUT_DIR)/SecureRecommendations

#Build the test project
#prepend required compiler flags
test: CXXFLAGS := $(RELEASE_OPTIMIZATION_LEVEL) $(RELEASE_DEFINES) $(CXXFLAGS)
test: directories clean libs $(OUTPUT_DIR)/Test
	cp $(RESOURCES_DIR)/config.xml $(OUTPUT_DIR)
	@echo "\n\nRunning tests!\n\n"
	$(OUTPUT_DIR)/Test $(OUTPUT_DIR)/config.xml

#Clear the intermediate and output folders
clean:
	rm -rf $(OUTPUT_DIR)/* $(INTERMEDIATE_DIR)/*
	
#Build object files. Yeah, it will call mkdir more times than needed, but who cares?
#Each .cpp file represents a compilation unit and produces one object file
$(INTERMEDIATE_DIR)/$(UTILS_DIR)/%.o: $(UTILS_DIR)/%.cpp
	mkdir -p $(INTERMEDIATE_DIR)/$(UTILS_DIR)
	$(CXX) $< $(LIBCXXFLAGS) -o $@
	
$(INTERMEDIATE_DIR)/$(CORE_DIR)/%.o: $(CORE_DIR)/%.cpp
	mkdir -p $(INTERMEDIATE_DIR)/$(CORE_DIR)
	$(CXX) $< $(LIBCXXFLAGS) -o $@
	
$(INTERMEDIATE_DIR)/$(PRIVATE_RECOMMENDATIONS_UTILS_DIR)/%.o: $(PRIVATE_RECOMMENDATIONS_UTILS_DIR)/%.cpp
	mkdir -p $(INTERMEDIATE_DIR)/$(PRIVATE_RECOMMENDATIONS_UTILS_DIR)
	$(CXX) $< $(LIBCXXFLAGS) -o $@
	
$(INTERMEDIATE_DIR)/$(SECURE_FACE_RECOGNITION_UTILS_DIR)/%.o: $(SECURE_FACE_RECOGNITION_UTILS_DIR)/%.cpp
	mkdir -p $(INTERMEDIATE_DIR)/$(SECURE_FACE_RECOGNITION_UTILS_DIR)
	$(CXX) $< $(LIBCXXFLAGS) -o $@
	
$(INTERMEDIATE_DIR)/$(PRIVATE_RECOMMENDATIONS_DIR)/%.o: $(PRIVATE_RECOMMENDATIONS_DIR)/%.cpp
	mkdir -p $(INTERMEDIATE_DIR)/$(PRIVATE_RECOMMENDATIONS_DIR)
	$(CXX) $< $(LIBCXXFLAGS) -o $@
	
$(INTERMEDIATE_DIR)/$(PRIVATE_RECOMMENDATIONS_DATA_PACKING_DIR)/%.o: $(PRIVATE_RECOMMENDATIONS_DATA_PACKING_DIR)/%.cpp
	mkdir -p $(INTERMEDIATE_DIR)/$(PRIVATE_RECOMMENDATIONS_DATA_PACKING_DIR)
	$(CXX) $< $(LIBCXXFLAGS) -o $@
	
$(INTERMEDIATE_DIR)/$(SECURE_EXTREMUM_SELECTION_DIR)/%.o: $(SECURE_EXTREMUM_SELECTION_DIR)/%.cpp
	mkdir -p $(INTERMEDIATE_DIR)/$(SECURE_EXTREMUM_SELECTION_DIR)
	$(CXX) $< $(LIBCXXFLAGS) -o $@
	
$(INTERMEDIATE_DIR)/$(SECURE_FACE_RECOGNITION_DIR)/%.o: $(SECURE_FACE_RECOGNITION_DIR)/%.cpp
	mkdir -p $(INTERMEDIATE_DIR)/$(SECURE_FACE_RECOGNITION_DIR)
	$(CXX) $< $(LIBCXXFLAGS) -o $@
	
$(INTERMEDIATE_DIR)/$(SECURE_RECOMMENDATIONS_DIR)/%.o: $(SECURE_RECOMMENDATIONS_DIR)/%.cpp
	mkdir -p $(INTERMEDIATE_DIR)/$(SECURE_RECOMMENDATIONS_DIR)
	$(CXX) $< $(LIBCXXFLAGS) -o $@

$(INTERMEDIATE_DIR)/$(TEST_DIR)/%.o: $(TEST_DIR)/%.cpp
	mkdir -p $(INTERMEDIATE_DIR)/$(TEST_DIR)
	$(CXX) $< $(LIBCXXFLAGS) -o $@
	
#Create the library archives
$(OUTPUT_DIR)/libUtils.a: $(patsubst %.cpp, $(INTERMEDIATE_DIR)/%.o, $(wildcard $(UTILS_DIR)/*.cpp))
	ar rcs $@ $^
$(OUTPUT_DIR)/libCore.a: $(patsubst %.cpp, $(INTERMEDIATE_DIR)/%.o, $(wildcard $(CORE_DIR)/*.cpp))
	ar rcs $@ $^
$(OUTPUT_DIR)/libPrivateRecommendationsUtils.a: $(patsubst %.cpp, $(INTERMEDIATE_DIR)/%.o, $(wildcard $(PRIVATE_RECOMMENDATIONS_UTILS_DIR)/*.cpp))
	ar rcs $@ $^
$(OUTPUT_DIR)/libSecureFaceRecognitionUtils.a: $(patsubst %.cpp, $(INTERMEDIATE_DIR)/%.o, $(wildcard $(SECURE_FACE_RECOGNITION_UTILS_DIR)/*.cpp))
	ar rcs $@ $^
	
#Link executables
#make sure to place the libraries in the right order!!!
$(OUTPUT_DIR)/PrivateRecommendations: $(patsubst %.cpp, $(INTERMEDIATE_DIR)/%.o, $(wildcard $(PRIVATE_RECOMMENDATIONS_DIR)/*.cpp))
	$(LINKER) $^ -lPrivateRecommendationsUtils -lCore -lUtils $(LDFLAGS) -o $@
$(OUTPUT_DIR)/PrivateRecommendationsDataPacking: $(patsubst %.cpp, $(INTERMEDIATE_DIR)/%.o, $(wildcard $(PRIVATE_RECOMMENDATIONS_DATA_PACKING_DIR)/*.cpp))
	$(LINKER) $^ -lPrivateRecommendationsUtils -lCore -lUtils $(LDFLAGS) -o $@
$(OUTPUT_DIR)/SecureExtremumSelection: $(patsubst %.cpp, $(INTERMEDIATE_DIR)/%.o, $(wildcard $(SECURE_EXTREMUM_SELECTION_DIR)/*.cpp))
	$(LINKER) $^ -lPrivateRecommendationsUtils -lSecureFaceRecognitionUtils -lCore -lUtils $(LDFLAGS) -o $@
$(OUTPUT_DIR)/SecureFaceRecognition: $(patsubst %.cpp, $(INTERMEDIATE_DIR)/%.o, $(wildcard $(SECURE_FACE_RECOGNITION_DIR)/*.cpp))
	$(LINKER) $^ -lSecureFaceRecognitionUtils -lCore -lUtils $(LDFLAGS) -o $@
$(OUTPUT_DIR)/SecureRecommendations: $(patsubst %.cpp, $(INTERMEDIATE_DIR)/%.o, $(wildcard $(SECURE_RECOMMENDATIONS_DIR)/*.cpp))
	$(LINKER) $^ -lCore -lUtils -lsvm $(LDFLAGS) -o $@
$(OUTPUT_DIR)/Test: $(patsubst %.cpp, $(INTERMEDIATE_DIR)/%.o, $(wildcard $(TEST_DIR)/*.cpp))
	$(LINKER) $^ -lCore -lUtils $(LDFLAGS) -o $@