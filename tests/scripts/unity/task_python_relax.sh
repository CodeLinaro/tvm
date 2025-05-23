#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -euxo pipefail

source tests/scripts/setup-pytest-env.sh
export LD_LIBRARY_PATH="build:${LD_LIBRARY_PATH:-}"

# to avoid CI CPU thread throttling.
export TVM_BIND_THREADS=0
export TVM_NUM_THREADS=2

# setup cython
cd python; python3 setup.py build_ext --inplace; cd ..

# Run Relax tests
TVM_TEST_TARGETS="${TVM_RELAY_TEST_TARGETS:-llvm}" pytest tests/python/relax
TVM_TEST_TARGETS="${TVM_RELAY_TEST_TARGETS:-llvm}" pytest tests/python/dlight

# Run Relax examples
# python3 ./apps/relax_examples/mlp.py
# python3 ./apps/relax_examples/nn_module.py
# python3 ./apps/relax_examples/resnet.py

# Test for MSC
pytest tests/python/contrib/test_msc

# Test for OpenCLML
# pytest tests/python/relax/backend/clml/
