allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Cập nhật đường dẫn thư mục build của root project
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // Cập nhật đường dẫn thư mục build cho các subproject
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    // Đảm bảo rằng các subproject phụ thuộc vào app project
    project.evaluationDependsOn(":app")
}

// Đăng ký task clean để xóa thư mục build của toàn bộ dự án
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
