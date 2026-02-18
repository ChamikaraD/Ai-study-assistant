allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// IMPORTANT: Restore default Flutter build directory behavior
rootProject.buildDir = File(rootProject.projectDir.parentFile, "build")
subprojects {
    project.buildDir = File(rootProject.buildDir, project.name)
}
