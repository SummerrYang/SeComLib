/*
SeComLib
Copyright 2012-2013 TU Delft, Information Security & Privacy Lab (http://isplab.tudelft.nl/)

Contributors:
Inald Lagendijk (R.L.Lagendijk@TUDelft.nl)
Mihai Todor (todormihai@gmail.com)
Thijs Veugen (P.J.M.Veugen@tudelft.nl)
Zekeriya Erkin (z.erkin@tudelft.nl)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
/**
@file private_recommendations_data_packing/comparison_blinding_factor_cache_parameters.h
@brief Definition of struct ComparisonBlindingFactorCacheParameters.
@author Mihai Todor (todormihai@gmail.com)
*/

#ifndef COMPARISON_BLINDING_FACTOR_CACHE_PARAMETERS_HEADER_GUARD
#define COMPARISON_BLINDING_FACTOR_CACHE_PARAMETERS_HEADER_GUARD

//include our headers
#include "utils/config.h"
#include "core/big_integer.h"
#include "core/blinding_factor_cache_parameters.h"

//include C++ headers
#include "deque"

namespace SeComLib {
using namespace Core;

namespace PrivateRecommendationsDataPacking {
	/**
	@brief Comparison blinding factor cache parameter container struct
	*/
	struct ComparisonBlindingFactorCacheParameters : public BlindingFactorCacheParameters {
	public:
		/// Empty buckets @f$ (2^{l + 2})^i @f$
		const std::deque<BigInteger> emptyBuckets;

		/// Constructor
		ComparisonBlindingFactorCacheParameters (const std::string &configurationPath, const size_t l, const std::deque<BigInteger> &emptyBuckets);

	private:
		/// Copy assignment operator - not implemented
		ComparisonBlindingFactorCacheParameters operator= (const ComparisonBlindingFactorCacheParameters &);
	};
}//namespace PrivateRecommendationsDataPacking
}//namespace SeComLib

#endif//COMPARISON_BLINDING_FACTOR_CACHE_PARAMETERS_HEADER_GUARD