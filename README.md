# vcpkg-registry
A vcpkg registry for customized ports and own libraries.

![Last Update](https://img.shields.io/github/last-commit/mbeckh/vcpkg-registry/master?label=Last+Update&style=flat-square)
[![Ports](https://img.shields.io/github/actions/workflow/status/mbeckh/vcpkg-registry/build.yml?branch=master&label=Ports&logo=GitHub&style=flat-square)](https://github.com/mbeckh/vcpkg-repository/actions)
[![License](https://img.shields.io/github/license/mbeckh/vcpkg-registry?label=License&style=flat-square)](https://github.com/mbeckh/vcpkg-registry/blob/master/LICENSE)

## Documentation
Please see the following resources in the [vcpkg documentation from Microsoft](https://learn.microsoft.com/en-us/vcpkg/) on how to use this repository.
-   [Using Registries](https://learn.microsoft.com/en-us/vcpkg/users/registries) 
-   [vcpkg-configuration.json Reference](https://learn.microsoft.com/en-us/vcpkg/reference/vcpkg-configuration-json)

## Workflows
Use the workflow mbeckh/vcpkg-registry/.github/workflows/run-clean_packages.yml to delete outdated versions of packages.
The job is triggered once each week only.

Inputs:
-   `older-than-days` - Delete all versions of a package which are older than this number of days, but always keep at
    least on version of a package (optional, default is 120). Still one version of each package is retained even if it
    is older.

-   `delete` - Make the workflow submit delete calls, else triggers a dry-run (optional, default is `false`).

Secrets:
-   `VCPKG_REGISTRY_TOKEN` - A token which has permission to call repository dispatch on this repository.

## Dependencies
The following diagram shows the dependencies of the packages. Host-only dependencies are shown using dotted lines, dependencies used only by tests are printed with reduced line thickness.

~~~mermaid
flowchart BT
  subgraph vcpkg
    direction LR
    vcpkg-cmake>vcpkg-cmake]
    vcpkg-cmake-config>vcpkg-cmake-config]
  end
  
  subgraph args
    args#lib([lib])
    
    args#lib -.-> vcpkg-cmake
    args#lib -.-> vcpkg-cmake-config
  end

  subgraph detours
    detours#lib([lib])
    
    detours#lib -.-> vcpkg-cmake
    detours#lib -.-> vcpkg-cmake-config
  end

  subgraph fmt
    fmt#lib([lib])
    
    fmt#lib -.-> vcpkg-cmake
    fmt#lib -.-> vcpkg-cmake-config
  end

  subgraph gtest
    gtest#lib([lib])
    
    gtest#lib -.-> vcpkg-cmake
    gtest#lib -.-> vcpkg-cmake-config
  end

  subgraph cmake-utils
    cmake-utils#tests[/tests/]
    
    cmake-utils#tests --> fmt#lib
  end

  subgraph detours-gmock
    direction RL
    detours-gmock#lib([lib])
    detours-gmock#tests[/tests/]
  
    detours-gmock#lib ==> detours#lib
    detours-gmock#lib ==> gtest#lib
    detours-gmock#lib -..-> vcpkg-cmake
    detours-gmock#lib -..-> vcpkg-cmake-config
    detours-gmock#tests --> detours-gmock#lib
  end

  subgraph common-cpp-testing
    direction RL
    common-cpp-testing#lib([lib])
    common-cpp-testing#tests[/tests/]
  
    common-cpp-testing#lib ===> detours-gmock#lib
    common-cpp-testing#lib ===> gtest#lib
    common-cpp-testing#lib -...-> vcpkg-cmake
    common-cpp-testing#lib -...-> vcpkg-cmake-config
    common-cpp-testing#tests --> common-cpp-testing#lib
  end

  subgraph common-cpp
    direction RL
    common-cpp#tests[/tests/]
    common-cpp#lib([lib])
       
    common-cpp#lib ===> fmt#lib
    common-cpp#lib -...-> vcpkg-cmake
    common-cpp#lib -...-> vcpkg-cmake-config
    common-cpp#tests --> common-cpp#lib
    common-cpp#tests --> common-cpp-testing#lib
    common-cpp#tests --> detours-gmock#lib
  end

  subgraph systemtools
    direction RL
    systemtools#lib([lib])
    systemtools#backup(backup)
    systemtools#tests[/tests/]
    
    systemtools#lib ===> common-cpp#lib
    systemtools#lib ====> fmt#lib
    systemtools#backup ==> systemtools#lib
    systemtools#backup ====> args#lib
    systemtools#tests --> systemtools#lib
    systemtools#tests ---> common-cpp-testing#lib
    systemtools#tests ---> detours-gmock#lib
  end
~~~

## License
The code of this repository is released under the MIT License. Please see [LICENSE](LICENSE) and [NOTICE](NOTICE) for details. Please read the documentation of the packages for their respective licenses.
