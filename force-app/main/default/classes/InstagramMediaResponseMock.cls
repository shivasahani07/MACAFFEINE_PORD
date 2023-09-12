public class InstagramMediaResponseMock implements HttpCalloutMock {
    public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('{"caption":"","media_type":"IMAGE","media_url":"https://scontent-yyz1-1.cdninstagram.com/v/t51.29350-15/362372544_202210982513258_8393266818570877071_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=8ae9d6&_nc_ohc=zDVNJvSU5nQAX-q9BIQ&_nc_ht=scontent-yyz1-1.cdninstagram.com&edm=AEQ6tj4EAAAA&oh=00_AfDyA7nu_-Eb-opTdrkuIoIGC-hy18E7Uah6s5wa8oWQnQ&oe=64C8477E","username":"utilitarian_labs","comments":{"data":[{"text":"@utilitarian_labs yes all good 😊","username":"kumar_shubham_29","id":"17925432917740784","commentId":"","replies":{"data":[{"text":"Reply text 1","username":"user1","id":"17851087209098192","timestamp":"2023-07-29T12:40:00+0000"},{"text":"Reply text 2","username":"user2","id":"17851087209098193","timestamp":"2023-07-29T12:42:30+0000"}]},"timestamp":"17975260817396560"}]},"permalink":"https://www.instagram.com/p/CvFLEeVPZ5W/","id":"17932309565706946","timestamp":"2023-07-29T12:34:56+0000"}');
        return res;
    }
}