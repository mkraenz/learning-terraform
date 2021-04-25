setTimeout(() => {
  const child = document.createElement("img");
  child.setAttribute("src", "https://source.unsplash.com/random/300x300");
  child.setAttribute("width", "300");
  child.setAttribute("height", "300");
  document.querySelector("#jsroot").appendChild(child);
}, 2000);

console.log("js finished");
