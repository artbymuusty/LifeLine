// android/build.gradle.kts

import org.gradle.api.file.Directory
import org.gradle.api.tasks.Delete
import com.android.build.api.dsl.LibraryExtension
import org.gradle.kotlin.dsl.configure
import org.gradle.kotlin.dsl.withType
import com.android.build.gradle.LibraryPlugin

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Centralize build outputs in a top-level 'build' directory
val newBuildDir: Directory = rootProject
    .layout
    .buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // Redirect each subproject's build output under the centralized build directory
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Ensure evaluation ordering when necessary
    project.evaluationDependsOn(":app")

    // Assign a namespace to all Android library modules (fixes AGP 8+ namespace requirement)
    plugins.withType<LibraryPlugin> {
        extensions.configure<LibraryExtension> {
            // Replace with your app's actual application namespace
            namespace = "com.mstfr.acilyardimapp"
        }
    }
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
