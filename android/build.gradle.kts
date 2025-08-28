allprojects {
    repositories {
        google()
        mavenCentral()
    }

    configurations.matching { it.name.contains("coreLibraryDesugaring", ignoreCase = true) }.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "com.android.tools" &&
                requested.name == "desugar_jdk_libs" &&
                (requested.version == null || requested.version!! < "2.1.4")
            ) {
                useVersion("2.1.5")
                because("flutter_local_notifications requires desugar_jdk_libs >= 2.1.4")
            }
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
